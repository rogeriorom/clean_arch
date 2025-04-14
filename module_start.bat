@echo off
setlocal enabledelayedexpansion

:: Solicita o nome do módulo
set /p result=Digite o nome do módulo em letras minúsculas no padrão snake_case: 

:: Converte para minúsculas e substitui caracteres especiais
set "module_name=%result%"
call :replace_chars module_name "áãâéêíóôõúç" "aaaeeiooouc"
set "module_camel_case="
for %%a in (%module_name%) do (
    set "word=%%a"
    set "module_camel_case=!module_camel_case!!word:~0,1!!word:~1!"
)

:: Primeiro caractere em minúsculo
set "module_lower_camel_case=!module_camel_case:~0,1!"
set "module_lower_camel_case=!module_lower_camel_case:~0,1!"

:: Criar a pasta do módulo
set "module_dir=lib\modules\%module_name%"
mkdir "%module_dir%"

:: Cria as pastas de dados
mkdir "%module_dir%\data"
mkdir "%module_dir%\data\datasources"
echo abstract class %module_camel_case%Datasource {} > "%module_dir%\data\datasources\%module_name%_datasource.dart"
echo import "%module_name%_datasource.dart"; >> "%module_dir%\data\datasources\%module_name%_datasource_imp.dart"
echo class %module_camel_case%DatasourceImp implements %module_camel_case%Datasource {} >> "%module_dir%\data\datasources\%module_name%_datasource_imp.dart"

:: Models
mkdir "%module_dir%\data\models"

:: Repositories
mkdir "%module_dir%\data\repositories"
echo import "..\domain\repositories\%module_name%_repository.dart"; > "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo import "..\datasources\%module_name%_datasource.dart"; >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo class %module_camel_case%RepositoryImp implements %module_camel_case%Repository { >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo     %module_camel_case%Datasource _%module_lower_camel_case%Datasource; >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo. >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo     %module_camel_case%RepositoryImp({ >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo         required %module_camel_case%Datasource %module_lower_camel_case%Datasource >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo     }): _%module_lower_camel_case%Datasource = %module_lower_camel_case%Datasource; >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"
echo } >> "%module_dir%\data\repositories\%module_name%_repository_imp.dart"

:: Cria as pastas do domínio
mkdir "%module_dir%\domain"
mkdir "%module_dir%\domain\dtos"
mkdir "%module_dir%\domain\entities"
mkdir "%module_dir%\domain\repositories"
echo abstract class %module_camel_case%Repository {} > "%module_dir%\domain\repositories\%module_name%_repository.dart"
mkdir "%module_dir%\domain\usecases"

:: Cria as pastas de apresentação
mkdir "%module_dir%\presentation"
mkdir "%module_dir%\presentation\controllers"
echo import "..\..\shared\domain\bases\shared_base_controller.dart"; > "%module_dir%\presentation\controllers\%module_name%_controller.dart"
echo abstract class %module_camel_case%Controller extends SharedBaseController {} >> "%module_dir%\presentation\controllers\%module_name%_controller.dart"
echo class %module_camel_case%ControllerImp extends %module_camel_case%Controller {} >> "%module_dir%\presentation\controllers\%module_name%_controller.dart"

mkdir "%module_dir%\presentation\pages"
echo import 'package:flutter/material.dart'; > "%module_dir%\presentation\pages\%module_name%_page.dart"
echo import 'package:flutter_modular/flutter_modular.dart'; >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo import '../../../shared/presentation/widgets/shared_app_bar.dart'; >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo import '../../../shared/presentation/widgets/shared_scaffold.dart'; >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo import '../controllers/%module_name%_controller.dart'; >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo class %module_camel_case%Page extends StatefulWidget { >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo   const %module_camel_case%Page({super.key}); >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo. >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo   @override >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo   State<%module_camel_case%Page> createState() => _%module_camel_case%PageState(); >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo } >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo class _%module_camel_case%PageState extends State<%module_camel_case%Page> { >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo   final _controller = Modular.get<%module_camel_case%Controller>(); >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo. >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo   @override >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo   Widget build(BuildContext context) => SharedScaffold( >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo         appBar: SharedAppBar(title: ''), >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo         baseController: _controller, >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo         body: Column( >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo           crossAxisAlignment: CrossAxisAlignment.start, >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo           children: [], >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo         ), >> "%module_dir%\presentation\pages\%module_name%_page.dart"
echo       ); >> "%module_dir%\presentation\pages\%module_name%_page.dart"

mkdir "%module_dir%\presentation\widgets"

:: Cria o módulo e as rotas
echo abstract class %module_camel_case%Routes { > "%module_dir%\%module_name%_routes.dart"
echo   static const %module_lower_camel_case% = '/%module_lower_camel_case'; >> "%module_dir%\%module_name%_routes.dart"
echo } >> "%module_dir%\%module_name%_routes.dart"
echo import 'package:flutter_modular/flutter_modular.dart'; > "%module_dir%\%module_name%_module.dart"
echo import '../../app/app_module.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import '../shared/domain/bases/shared_base_module.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import 'data/datasources/%module_name%_datasource.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import 'data/datasources/%module_name%_datasource_imp.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import 'data/repositories/%module_name%_repository_imp.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import 'domain/repositories/%module_name%_repository.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import 'presentation/controllers/%module_name%_controller.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import 'presentation/pages/%module_name%_page.dart'; >> "%module_dir%\%module_name%_module.dart"
echo import '%module_name%_routes.dart'; >> "%module_dir%\%module_name%_module.dart"
echo class %module_camel_case%Module extends SharedBaseModule { >> "%module_dir%\%module_name%_module.dart"
echo   @override >> "%module_dir%\%module_name%_module.dart"
echo   void binds(Injector i) { >> "%module_dir%\%module_name%_module.dart"
echo     i.addLazySingleton<%module_camel_case%Datasource>(%module_camel_case%DatasourceImp.new); >> "%module_dir%\%module_name%_module.dart"
echo     i.addLazySingleton<%module_camel_case%Repository>(%module_camel_case%RepositoryImp.new); >> "%module_dir%\%module_name%_module.dart"
echo     i.add<%module_camel_case%Controller>(%module_camel_case%ControllerImp.new); >> "%module_dir%\%module_name%_module.dart"
echo     super.binds(i); >> "%module_dir%\%module_name%_module.dart"
echo   } >> "%module_dir%\%module_name%_module.dart"
echo   @override >> "%module_dir%\%module_name%_module.dart"
echo   void routes(RouteManager r) { >> "%module_dir%\%module_name%_module.dart"
echo     r.child( >> "%module_dir%\%module_name%_module.dart"
echo       %module_camel_case%Routes.%module_lower_camel_case%, >> "%module_dir%\%module_name%_module.dart"
echo       transition: appTransition, >> "%module_dir%\%module_name%_module.dart"
echo       child: (_) => const %module_camel_case%Page(), >> "%module_dir%\%module_name%_module.dart"
echo     ); >> "%module_dir%\%module_name%_module.dart"
echo     super.routes(r); >> "%module_dir%\%module_name%_module.dart"
echo   } >> "%module_dir%\%module_name%_module.dart"

echo Estrutura de pastas criada para o módulo: '%module_name%'
goto :eof

:replace_chars
setlocal
set var_name=%1
set chars=%2
set replacement=%3
set var_value=!%var_name%!
for /L %%i in (0,1,127) do (
    set "char=!chars:~%%i,1!"
    if not "!char!"=="" (
        set "rep_char=!replacement:~%%i,1!"
        set var_value=!var_value:%char%=%rep_char%!
    )
)
endlocal & set %var_name%=%var_value%
exit /b
