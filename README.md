# Projeto de Otimização do Delivery Center

### A documentação do projeto se encontra no meu [Medium]()

### Overview do Projeto
---

O Projeto se trata sobre um Centro de operações de delivery, que conta com diferentes bases pra trabalharmos e analisarmos para poder gerar uma otimização de acordo com a necessidade de cada área.

No projeto, foi feito seguindo as normas e orientações da metodologia CRISP-DM.

### DATA

Data: O conjunto de dados foi disponibilizado no [Kaggle](https://www.kaggle.com/datasets/nosbielcs/brazilian-delivery-center).

### Ferramentas

- SQL - Demandas das Áreas e Perguntas de Negócio
- Python - Análise exploratória inicial


### Critérios de Sucesso

- Para criação e condução da análise, foi feito com base em resolver as perguntas de negócio para um maior entendimento do nosso processo do dia a dia e também atender as demandas geradas pelas partes interessadas.
---

#### Perguntas de Negócio


- Qual é o tempo médio de entrega dos pedidos em cada hub?

> O `PHP SHOPPING` é o Hub com menor tempo de entrega sendo apenas 51 minutos.

- Quais são os canais de venda com maior volume de pedidos e receita?

> Pela receita o top 3 é composto por `FOOD PLACE`, `CHOCO PLACE` e `LISBON PLACE`. Já pelo total de pedidos, é liderado por `FOOD PLACE`, `EATS PLACE` e `VELOCITY PLACE`.

- Qual é o tempo médio entre o pagamento e o processamento dos pedidos?

> O tempo médio é de 20 minutos.

- Quais são as lojas com maior e menor taxa de pedidos entregues?

> A `IUMPICA` tem a maior taxa de pedidos entregues sendo 26% e existem 28 lojas com apenas 1 pedido entregue com a taxa de 0,00028%

- Quantos pedidos, em média, cada entregador realiza por dia?

> A média diária de entregas foi de 2961, e o entregador com a maior média de entregas no dia foi de 92.

- Quais são os dias e horários de pico de pedidos?

> Os dois maiores picos ocorreram na sexta feira nos horários das 22 e 23 horas do dia.

- Quais são os métodos de pagamento mais utilizados e a taxa de rejeição por método?

> O pagamento `ONLINE` é o método mais utilizado dentro da plataforma e os métodos com a menor taxa de rejeição são `VOUCHER STORE`, `PAYMENT_LINK`, `CREDIT_STORE`, `VOUCHER OL` e `BANK_TRANSFER_DC`. O que faz sentido quando pensamos que a maioria são cupons diretamente da loja.

- Qual é o ticket médio por canal de venda?

> O maior ticket médio foi encontrado na `AHORA PLACE` de 589 $ e o menor no `WEAR PLACE` de 27 $.

- Quais lojas têm maior volume de vendas no modelo 'good' e no modelo 'food'?

> Para os produtos do segmento Good a loja `SALITO` lidera com 12808 pedidos, já no modelo Food `IUMPICA` tem o maior número de pedidos com 97264.
