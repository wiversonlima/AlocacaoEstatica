# Como Construir Mapas com Alocação Estática

Este projeto demonstra como construir mapas e grids de jogo usando **alocação estática** em C++. O programa apresenta diferentes técnicas para criar mapas 2D utilizando arrays bidimensionais com tamanho fixo.

## 🎯 Objetivo

Ensinar conceitos de alocação estática através da criação de mapas para jogos, incluindo:
- Representação de terrenos usando caracteres
- Estruturas de dados estáticas para mapas
- Algoritmos básicos de geração de mapas
- Diferentes tipos de cenários (labirintos, ilhas, etc.)

## 🗺️ Tipos de Mapas Implementados

### 1. Mapa Básico
- Grid simples com elementos posicionados manualmente
- Demonstra posicionamento de jogador, inimigos e itens

### 2. Labirinto
- Geração automática de paredes e corredores
- Sistema de entrada e saída
- Ideal para jogos de exploração

### 3. Ilha do Tesouro
- Mapa com diferentes biomas (água, terra, montanhas)
- Geração de formas orgânicas usando algoritmos matemáticos
- Vegetação procedural

## 🏗️ Estrutura do Código

### Estrutura Principal
```cpp
struct MapaEstatico {
    char nome[MAX_NOME];           // Nome do mapa
    int largura, altura;           // Dimensões
    char grid[MAX_LINHAS][MAX_COLUNAS]; // Grid principal
    char legenda[256][50];         // Descrições dos elementos
};
```

### Funções Principais
- `inicializarMapa()` - Configura um novo mapa
- `exibirMapa()` - Renderiza o mapa na tela
- `adicionarElemento()` - Posiciona elementos no grid
- `criarBordas()` - Gera paredes nas bordas
- `criarLabirinto()` - Algoritmo de geração de labirinto
- `criarIlha()` - Algoritmo de geração de ilha

## 📊 Legenda de Elementos

| Símbolo | Descrição |
|---------|-----------|
| `.` | Terreno vazio |
| `#` | Parede/Obstáculo |
| `~` | Água |
| `^` | Montanha |
| `T` | Árvore |
| `P` | Jogador |
| `E` | Inimigo |
| `$` | Tesouro |

## 🔧 Como Compilar e Executar

### Requisitos
- Compilador C++ (Visual Studio, GCC, Clang)
- Sistema operacional: Windows, Linux ou macOS

### Compilação
#### Visual Studio
1. Abra o arquivo `AlocacaoEstatica.sln`
2. Compile o projeto (Ctrl+Shift+B)
3. Execute (F5)

#### Linha de Comando (GCC/Clang)
```bash
g++ -o mapas Estatica.cpp
./mapas
```

## 💡 Conceitos de Alocação Estática

### Vantagens
- ✅ **Performance**: Acesso O(1) aos elementos
- ✅ **Simplicidade**: Não requer gerenciamento manual de memória
- ✅ **Segurança**: Menos propenso a vazamentos de memória
- ✅ **Previsibilidade**: Uso de memória conhecido em tempo de compilação

### Limitações
- ❌ **Flexibilidade**: Tamanho fixo, não pode ser alterado em runtime
- ❌ **Memória**: Pode desperdiçar espaço se o mapa for pequeno
- ❌ **Escalabilidade**: Limitado pelas constantes MAX_LINHAS e MAX_COLUNAS

### Quando Usar
- Jogos retro/arcade com mapas de tamanho fixo
- Protótipos e demonstrações educacionais
- Sistemas embarcados com restrições de memória
- Situações onde a performance é crítica

## 🎮 Aplicações Práticas

### Jogos Clássicos
- **Pac-Man**: Labirintos com pellets e fantasmas
- **Snake**: Grid simples para movimentação
- **Tetris**: Área de jogo fixa
- **Bomberman**: Mapas de blocos destrutíveis

### Algoritmos de Pathfinding
Os mapas criados podem ser usados com algoritmos como:
- A* (A-star)
- Dijkstra
- Breadth-First Search (BFS)
- Depth-First Search (DFS)

## 📚 Exercícios Propostos

1. **Básico**: Modifique as constantes para criar mapas maiores
2. **Intermediário**: Implemente uma função para salvar/carregar mapas
3. **Avançado**: Crie um algoritmo de geração de dungeons
4. **Expert**: Implemente pathfinding A* para navegação

## 🤝 Contribuições

Este é um projeto educacional. Sugestões para melhorias são bem-vindas:
- Novos tipos de mapas
- Algoritmos de geração procedural
- Otimizações de performance
- Melhorias na interface

## 📄 Licença

Projeto educacional de código aberto. Use livremente para aprendizado e ensino.

---

**Nota**: Este projeto demonstra conceitos fundamentais de estruturas de dados e pode ser expandido para jogos mais complexos usando alocação dinâmica conforme necessário.