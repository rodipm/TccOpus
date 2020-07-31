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

Eles são representados como classes dart contendo tipo, childDetails (corresponde as possíveis configurações deste elemento) e childContent (representando widgets do Flutter que representam o elemento visualmente). 

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

+ `content_based_router.dart`

Arquivo .dart contendo a definição do componente, incluindo sua aparência e possíveis configurações. Estas configurações são consumidas no arquivo python responsável pelo parse do componente.

+ `ContentBasedRouter.png`

ícone do componente

## Geração de um componente de forma automática

Após estruturar o componente, pode-se executar o script python `gerar_componentes.py` localizado no diretório raiz do projeto para que os arquivos sejam adicionados aos diretórios corretos dentro do projeto, além de gerar arquivos de import automaticamente.
