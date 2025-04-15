#!/bin/bash

# Solicita o nome da pasta
read -p "Digite o nome do módulo em letras minúsculas no padrão snake_case: " result

# Nomes das classes
module_name=$(echo "$result" | tr '[:upper:]' '[:lower:]' | tr 'áãâéêíóôõúç' 'aaaeeiooouc')
module_camel_case=$(echo "$module_name" | awk -F_ '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' OFS="")
module_lower_camel_case="$(echo "${module_camel_case:0:1}" | tr '[:upper:]' '[:lower:]')${module_camel_case:1}"

# Criar a pasta do módulo
module_dir="lib/modules/$module_name"
mkdir -p "$module_dir"

########## Cria as pastas de dados ##########
mkdir -p "$module_dir/data"

# Datasources
mkdir -p "$module_dir/data/datasources"
cat <<EOF > $module_dir/data/datasources/$module_name\_datasource.dart
abstract class ${module_camel_case}Datasource {}
EOF
cat <<EOF > $module_dir/data/datasources/$module_name\_datasource_imp.dart
import '${module_name}_datasource.dart';

class ${module_camel_case}DatasourceImp implements ${module_camel_case}Datasource {}
EOF

# Models
mkdir -p "$module_dir/data/models"

# Repositories
mkdir -p "$module_dir/data/repositories"
cat <<EOF > $module_dir/data/repositories/$module_name\_repository_imp.dart
import '../../domain/repositories/${module_name}_repository.dart';
import '../datasources/${module_name}_datasource.dart';

class ${module_camel_case}RepositoryImp implements ${module_camel_case}Repository {
    final ${module_camel_case}Datasource _${module_lower_camel_case}Datasource;

    ${module_camel_case}RepositoryImp({
        required ${module_camel_case}Datasource ${module_lower_camel_case}Datasource,
    }): _${module_lower_camel_case}Datasource = ${module_lower_camel_case}Datasource;
}
EOF

########## Cria as pastas do domínio ##########
mkdir -p "$module_dir/domain"

# DTOs
mkdir -p "$module_dir/domain/dtos"

# Entities
mkdir -p "$module_dir/domain/entities"

# Repositories
mkdir -p "$module_dir/domain/repositories"
cat <<EOF > $module_dir/domain/repositories/$module_name\_repository.dart
abstract class ${module_camel_case}Repository {}
EOF

# Usecases
mkdir -p "$module_dir/domain/usecases"

########## Cria as pastas de apresentação ##########
mkdir -p "$module_dir/presentation"

# Controllers
mkdir -p "$module_dir/presentation/controllers"
cat <<EOF > $module_dir/presentation/controllers/$module_name\_controller.dart
import '../../../shared/domain/bases/shared_base_controller.dart';

abstract class ${module_camel_case}Controller extends SharedBaseController {}

class ${module_camel_case}ControllerImp extends ${module_camel_case}Controller {}
EOF

# Pages
mkdir -p "$module_dir/presentation/pages"
cat <<EOF > $module_dir/presentation/pages/$module_name\_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/presentation/widgets/shared_app_bar.dart';
import '../../../shared/presentation/widgets/shared_scaffold.dart';
import '../controllers/${module_name}_controller.dart';

class ${module_camel_case}Page extends StatefulWidget {
  const ${module_camel_case}Page({super.key});

  @override
  State<${module_camel_case}Page> createState() => _${module_camel_case}PageState();
}

class _${module_camel_case}PageState extends State<${module_camel_case}Page> {
  final _controller = Modular.get<${module_camel_case}Controller>();

  @override
  Widget build(BuildContext context) => SharedScaffold(
        appBar: SharedAppBar(title: ''),
        baseController: _controller,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      );
}
EOF

# Widgets
mkdir -p "$module_dir/presentation/widgets"

########## Criar o modulo e as rotas ##########
cat <<EOF > $module_dir/${module_name}_routes.dart
abstract class ${module_camel_case}Routes {
  static const $module_lower_camel_case = '/$module_lower_camel_case';
}
EOF
cat <<EOF > $module_dir/${module_name}_module.dart
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/app_module.dart';
import '../shared/domain/bases/shared_base_module.dart';
import 'data/datasources/${module_name}_datasource.dart';
import 'data/datasources/${module_name}_datasource_imp.dart';
import 'data/repositories/${module_name}_repository_imp.dart';
import 'domain/repositories/${module_name}_repository.dart';
import 'presentation/controllers/${module_name}_controller.dart';
import 'presentation/pages/${module_name}_page.dart';
import '${module_name}_routes.dart';

class ${module_camel_case}Module extends SharedBaseModule {
  @override
  void binds(Injector i) {
    // Datasources
    i.addLazySingleton<${module_camel_case}Datasource>(${module_camel_case}DatasourceImp.new);
    // Repositories
    i.addLazySingleton<${module_camel_case}Repository>(${module_camel_case}RepositoryImp.new);
    // Usecases
    // Controllers
    i.add<${module_camel_case}Controller>(${module_camel_case}ControllerImp.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      ${module_camel_case}Routes.$module_lower_camel_case,
      transition: appTransition,
      child: (_) => const ${module_camel_case}Page(),
    );
    super.routes(r);
  }
}
EOF

############################################################
echo "Estrutura de pastas criada para o módulo: '$module_name'"
