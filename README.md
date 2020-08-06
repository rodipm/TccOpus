# Trabalho de Conclusão de Curso - POLI USP - Opus Software

### Rodrigo Perrucci Macharelli

### Proposta
[Tema do TCC proposto pelo professor Ricardo Luis de Azevedo da Rocha](docs/Tema-Tcc.pdf)

### Textos sobre Camel
[Camel/README.md](sandbox/Camel/README.md)

# Documentação Preliminar

## Estruturação do Projeto

O projeto é dividido em front e back end, constituindo a interface da aplicação e o servidor e sistema de geração de código, respectivamente.

O front-end foi desenvolvido utilizando Flutter e está localizado na pasta `front`, enquanto o back-end foi desenvolvido em Python 3, localizado na pasta `back`.

A pasta `sandbox` foi utilizada para testes e estudos durante o proceso de desenvolvimento do projeto.

A pasta `docs` apresenta documentos pertinentes ao projeto de TCC.

# Front-End

Localizado na pasta `front` pode ser inicializado com o seguinte comando:

```
flutter run -d chrome
```

Assim o projeto é iniciado na interface web utilizando o chrome.

> OBS: Configurações adicionais podem ser necessárias para utilização do flutter web (https://flutter.dev/docs/get-started/web)

## Diretórios e Arquivos Importantes

### /lib

Este diretório contém todo o código fonte do projeto da interface da aplicação.

+ **main.dart**:

Responsável pela organização dos elementos do front-end (widgets) na tela e comunicação com o back-end

+ **/EipWidgets**: 

Cada elemento EIP que pode ser adicionado a lista de elementos arrastáveis e editáveis deve ser inserido neste diretório. 

Eles são representados como classes dart contendo tipo, componentConfigs (corresponde as possíveis configurações deste elemento) e componentWidget (representando widgets do Flutter que representam o elemento visualmente). 

Estes elementos seguem todos uma forma semelhante que pode ser observada nos arquivos. Em especial no arquivo `sample_eip.dart`.

+ **/LeftSidePane**

Painel de seleção de elementos EIP arrastáveis para serem inseridos no diagrama.

Requer importar as classes definidas nos EipWidgets, uma vez que consomem o widget 'icon' presente nas classes dos elementos, que é representação do elemento neste menu de seleção.

+ **/EditItemPane**

Painel de edição de elementos EIP. Cada tipo de elemento pode utilizar diferentes formas de representação para suas configurações, de forma a facilitar a utilização por parte do usuário.

Este widget é reponsável por verificar qual o tipo de representação e construir sua representação visual.

+ **/Lines**

Widget utilizado para representar as conexões entre elementos EIP no diagrama, formando uma flecha com linhas que partem da lateral direita do elemento fonte até a lateral esquerda do elemento a se conectar.

+ **/MoveableStackItem**

Widget básico que possibilita a movimentação dos elementos, possibilitando a criação de uma estrutura de diagrama editável do tipo Drag And Drop.

### /assets

Contém as imagens representativas dos elementos EIP no formato .png.

Fonte: https://github.com/JanKl/eip-icons/tree/master/png

### pubspec.yaml

Arquivo de configuração do projeto flutter. Inclui as dependências do projeto.

# Back-End

Localizado na pasta back, pode ser inicializado com o seguinte comando

```
python -m flask run
```

## Diretórios e Arquivos Importantes

### app.py

Arquivo principal do servidor, responsável pela implementação dos endpoints da API e orquestração dos sistemas de geração de código `code_generation` e sistema de persistência de projetos (TODO).


### /code_generation

Este diretório contém o código responsável pala função de geração de código por completo, isto é: Parse da entrada - `parser.py`, geração do código das rotas - `code_generator.py` e geração dos projetos Apache Camel - `project_generator.py`.

+ **/eip_components**:

Contém as classes representantes dos elementos eip contendo as funcionalidades necessárias para o parse e geração de código

+ **parser.py**:

Responsável pela verificação da estrutura do diagrama criado pelo usuário.

Efetua o parse baseado em regras de geração de uma gramática definida (sua definição se encontra no arquivo)

+ **code_generator.py**:

Responsável pela tradução do diagrama para código em Java utilizando regras e convenções da framework Apache Camel.

Gera também a lista com os nomes das dependências exigidas pelo projeto.

+ **project_generator.py**:

Consome os códigos das rotas e dependências geradas pelo `code_generator` para gerar os arquivos e estrutura de pastas necessárias para execução de um projeto Apache Camel utilizando Maven. 

### /projetos_gerados

Diretório contendo os arquivos .zip dos projetos gerados pelo sistema. Estes arquivos servem o propósito para serem disponibilizados para download, e devem ser removidos posteriormente (TODO).


# Componentes Eip

Este projeto atua com um editor de diagramas de fluxo de integração implementando elementos EIP contemplados pelo Apache Camel. Para o desenvolvimento e integração de um componente EIP ao projeto, deve-se seguir algumas convenções.

Cada elemento deve possuir uma pasta com seu nome no formato 'Camel Case' dentro do diretório `ComponentesEip` na raíz do projeto, na qual serão definidas as suas funcionalidades e configurações.

Um componente EIP é representado neste projeto da seguinte forma:
    + Definição das configurações
    + Definição da forma de apresentação do menu de configuração
    + Definição de aparência
    + Definição de parse
    + Ícone

Essas definições são consumidas pelo back e front-end para processar o componente EIP de forma correta.

## Estruturação de um Componente EIP

A forma de adicionar um elemento EIP a este projeto se baseia na criação de seu diretório contendo 3 arquivos. Para fins de exemplificação imagina-se um cenário no qual deseja-se adicionar o componente 'Content Based Router'.

Cria-se um diretório dentro de `ComponentesEip` com o nome 'ContentBasedRouter'. Dentro deste diretório deve-se criar os seguintes arquivos:

+ `content_based_router.py`

Arquivo python contendo uma classe chamada 'ContentBasedRouter' que extende e implementa a classe abstrada 'EipComponent'. Esta classe deve implementar o método parse utilizado pelo gerador de código.

```python
from .eip_component import EipComponent
from copy import deepcopy

class ContentBasedRouter(EipComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        choices = []
        for [child_node_number, choice] in current_node['choices']:
            if choice:
                rec_code, deps = generate_code(
                    items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                new_dependencies.update(deps)
                choices.append(f"\n\t.when({choice})\n\t\t" + rec_code)
            else:
                rec_code, deps = generate_code(
                    items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                new_dependencies.update(deps)
                choices.append(f"\n\t.otherwise()\n\t\t" + rec_code)

        return (generated_code + "\n.choice()" + "".join(choices) + "\n.end()", new_dependencies)

```

+ `content_based_router.dart`

Arquivo .dart contendo a definição da classe do componente, incluindo sua aparência e possíveis configurações. Estas configurações são consumidas no arquivo python responsável pelo parse do componente.

Um componente deve conter em sua classe os seguintes metodos e atributos:
+ final String type = "TipoDoComponente";
+ final String subType = "CategoriaDoComponente";
+ final double width;
+ final double height;
+ Widget componentWidget;
+ Map<String, dynamic> componentConfigs = {// Configurações do componente};
+ Map<String, dynamic> componentConfigControllers = {// Controladores de input do componente};
+ Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {// Logica para atualizar as configuracões do componente}
+ List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions, config, configControllers, editItems, baseWidget) { // Lógica de apresentação das configuraçoes do componente no menu de edição }
+ Construtor
+ Icon

    Exemplo de classe para utilizar como base:

```dart
import 'package:flutter/material.dart';

class SampleComponent {
  final String type = "SampleComponent";
  final String subType = "CategoriaDoComponente";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
      // Configurações do componente
  };

  Map<String, dynamic> componentConfigControllers = {
    // Controladores de input do componente
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
      // Logica para atualizar as configuracões do componente
  }

  List<Widget> buildEditPane(
      selectedItem, selectedItemID, itemsPositions, config, configControllers, editItems, baseWidget) {
    
    // Lógica de apresentação das configuraçoes do componente no menu de edição
    return editItems;
  }

  // Construtor do componente
  SampleComponent(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/SampleComponent.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget icon(Function insertNewEipItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
          feedback: componentWidget,
          onDraggableCanceled: (velocity, offset) {
            insertNewEipItem(this, offset);
          },
          child: componentWidget),
    );
  }
}

```


Exemplo do ContentBasedRouter

```dart
import 'package:flutter/material.dart';

class ContentBasedRouter {
  final String type = "ContentBasedRouter";
  final String subType = "MessageRouting";
  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "choices": null,
  };

  Map<String, dynamic> componentConfigControllers = {
    "contentBasedRouterControllers": {},
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    Map<String, dynamic> newComponentConfigs = {};
    newComponentConfigs.addAll({config: []});

    for (var choiceTargetID
        in configControllers["contentBasedRouterControllers"][config].keys) {
      newComponentConfigs[config].add([
        choiceTargetID,
        configControllers["contentBasedRouterControllers"][config]
                [choiceTargetID]
            .text
      ]);
    }
    return newComponentConfigs;
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    if (selectedItem.componentConfigs[config] == null) {
      configControllers["contentBasedRouterControllers"].addAll({config: {}});
      for (int i in itemsPositions[selectedItemID]["connectsTo"]) {
        configControllers["contentBasedRouterControllers"][config]
            .addAll({i: TextEditingController()});
        configControllers["contentBasedRouterControllers"][config][i].text =
            selectedItem.componentConfigs[config];

        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: config + " [$i]"),
            controller: configControllers["contentBasedRouterControllers"]
                [config][i],
          ),
        );
      }
    } else {
      configControllers["contentBasedRouterControllers"].addAll({config: {}});
      for (var i in selectedItem.componentConfigs[config]) {
        configControllers["contentBasedRouterControllers"][config]
            .addAll({i[0]: TextEditingController()});
        configControllers["contentBasedRouterControllers"][config][i[0]].text =
            i[1];

        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: config + " [${i[0]}]"),
            controller: configControllers["contentBasedRouterControllers"]
                [config][i[0]],
          ),
        );
      }

      for (int i in itemsPositions[selectedItemID]["connectsTo"]) {
        if (!configControllers["contentBasedRouterControllers"][config]
            .keys
            .toList()
            .contains(i)) {
          configControllers["contentBasedRouterControllers"][config]
              .addAll({i: TextEditingController()});
          configControllers["contentBasedRouterControllers"][config][i].text =
              "";

          editItems.add(
            TextFormField(
              decoration: InputDecoration(labelText: config + " [$i]"),
              controller: configControllers["contentBasedRouterControllers"]
                  [config][i],
            ),
          );
        }
      }
    }
    return editItems;
  }

  ContentBasedRouter(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ContentBasedRouter.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget icon(Function insertNewEipItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
          feedback: componentWidget,
          onDraggableCanceled: (velocity, offset) {
            insertNewEipItem(this, offset);
          },
          child: componentWidget),
    );
  }
}

```

+ `ContentBasedRouter.png`

ícone do componente

## Geração de um componente de forma automática

Após estruturar o componente, pode-se executar o script python `gerar_componentes.py` localizado no diretório raiz do projeto para que os arquivos sejam adicionados aos diretórios corretos dentro do projeto, além de gerar arquivos de import automaticamente.
