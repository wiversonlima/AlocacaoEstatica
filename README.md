# AlocacaoEstatica - Calculadora de Preços E-commerce

## Descrição

Este projeto implementa uma calculadora de preços para desenvolvimento de e-commerce WordPress + WooCommerce. O sistema utiliza **alocação estática** de preços, com valores predefinidos para diferentes tipos de projetos e funcionalidades.

## Funcionalidades

### Planos Base
- **Básico**: R$ 1.500,00 - Site básico WordPress + WooCommerce
- **Intermediário**: R$ 3.000,00 - Site intermediário com customizações
- **Avançado**: R$ 5.500,00 - Site avançado com funcionalidades complexas
- **Premium**: R$ 8.500,00 - Site premium com desenvolvimento customizado

### Funcionalidades Extras
- Design customizado (R$ 800,00)
- Integração sistemas de pagamento (R$ 400,00)
- Sistema gestão de estoque (R$ 600,00)
- Suporte multi-idiomas (R$ 500,00)
- SEO otimizado (R$ 300,00)
- Aplicativo mobile (R$ 2.000,00)
- Integração com ERP (R$ 1.200,00)
- Relatórios avançados (R$ 700,00)

### Escalonamento por Produtos
O sistema aplica multiplicadores baseados na quantidade de produtos:
- Até 50 produtos: 1.0x
- 51-200 produtos: 1.2x
- 201-500 produtos: 1.4x
- 501-1000 produtos: 1.6x
- 1001-2000 produtos: 1.8x
- Mais de 2000 produtos: 2.0x

## Como Compilar e Executar

### Requisitos
- Compilador C++ com suporte ao C++11
- Sistema operacional compatível (Windows, Linux, macOS)

### Compilação
```bash
cd AlocacaoEstatica
g++ -o AlocacaoEstatica Estatica.cpp -std=c++11
```

### Execução
```bash
./AlocacaoEstatica
```

## Exemplo de Uso

```
=== CALCULADORA DE PREÇOS E-COMMERCE ===
WordPress + WooCommerce

Planos base disponíveis:
1. Básico: R$ 1500.00 - Site básico WordPress + WooCommerce
2. Intermediário: R$ 3000.00 - Site intermediário com customizações
3. Avançado: R$ 5500.00 - Site avançado com funcionalidades complexas
4. Premium: R$ 8500.00 - Site premium com desenvolvimento customizado

Selecione o plano base (1-4): 2

Funcionalidades extras disponíveis:
1. Design customizado - R$ 800.00
2. Integração sistemas de pagamento - R$ 400.00
...

=== ORÇAMENTO DETALHADO ===
Plano base: Site intermediário com customizações - R$ 3000.00

Funcionalidades extras:
- Design customizado - R$ 800.00
- Integração sistemas de pagamento - R$ 400.00
Subtotal extras: R$ 1200.00

Número de produtos: 100
Multiplicador por complexidade: 1.2x

=========================
PREÇO TOTAL: R$ 5040.00
=========================

Observações:
- Preços incluem desenvolvimento e configuração inicial
- Manutenção mensal: R$ 252.00 (5% do valor total)
- Prazo de entrega: 25 dias úteis
```

## Estrutura do Código

- **Classe CalculadoraEcommerce**: Gerencia toda a lógica de cálculo
- **Alocação Estática**: Preços armazenados em estruturas de dados estáticas (maps)
- **Interface do Usuário**: Sistema interativo em linha de comando
- **Validação de Entrada**: Verificação de dados inseridos pelo usuário

## Resposta à Pergunta Original

**"Quanto cobrar por um e-commerce tipo WordPress com WooCommerce?"**

A resposta depende de vários fatores:

1. **Complexidade do projeto** (Básico a Premium)
2. **Funcionalidades específicas** necessárias
3. **Número de produtos** a serem gerenciados
4. **Customizações** de design e funcionalidade

Este sistema fornece uma base sólida para precificação, considerando os principais fatores que influenciam o custo de desenvolvimento de um e-commerce.

## Autor

Desenvolvido como solução para cálculo de preços de e-commerce WordPress/WooCommerce.