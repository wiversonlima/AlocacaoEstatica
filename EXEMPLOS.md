# Exemplos de Uso

Este documento contém exemplos práticos de como usar o sistema de mapas com alocação estática.

## Exemplo 1: Criando um Mapa Personalizado

```cpp
#include "Estatica.cpp"

int main() {
    MapaEstatico meuMapa;
    
    // Inicializa um mapa 10x8
    inicializarMapa(meuMapa, "Meu Primeiro Mapa", 10, 8);
    
    // Adiciona bordas
    criarBordas(meuMapa);
    
    // Posiciona elementos
    adicionarElemento(meuMapa, 3, 3, 'P'); // Jogador
    adicionarElemento(meuMapa, 5, 7, '$'); // Tesouro
    adicionarElemento(meuMapa, 4, 5, 'T'); // Árvore
    
    // Exibe o resultado
    exibirMapa(meuMapa);
    
    return 0;
}
```

## Exemplo 2: Sistema de Colisão Simples

```cpp
bool verificarColisao(const MapaEstatico& mapa, int linha, int coluna) {
    if (linha < 0 || linha >= mapa.altura || coluna < 0 || coluna >= mapa.largura) {
        return true; // Fora dos limites
    }
    
    char elemento = mapa.grid[linha][coluna];
    return (elemento == '#' || elemento == '~' || elemento == '^');
}

bool moverJogador(MapaEstatico& mapa, int linhaAtual, int colunaAtual, 
                 int novaLinha, int novaColuna) {
    if (!verificarColisao(mapa, novaLinha, novaColuna)) {
        mapa.grid[linhaAtual][colunaAtual] = '.';
        mapa.grid[novaLinha][novaColuna] = 'P';
        return true;
    }
    return false;
}
```

## Exemplo 3: Algoritmo de Flood Fill

```cpp
void floodFill(MapaEstatico& mapa, int linha, int coluna, char novoChar, char charOriginal) {
    if (linha < 0 || linha >= mapa.altura || coluna < 0 || coluna >= mapa.largura) {
        return;
    }
    
    if (mapa.grid[linha][coluna] != charOriginal) {
        return;
    }
    
    mapa.grid[linha][coluna] = novoChar;
    
    // Recursão para os 4 vizinhos
    floodFill(mapa, linha + 1, coluna, novoChar, charOriginal);
    floodFill(mapa, linha - 1, coluna, novoChar, charOriginal);
    floodFill(mapa, linha, coluna + 1, novoChar, charOriginal);
    floodFill(mapa, linha, coluna - 1, novoChar, charOriginal);
}
```

## Exemplo 4: Salvando e Carregando Mapas

```cpp
#include <fstream>

bool salvarMapa(const MapaEstatico& mapa, const char* nomeArquivo) {
    ofstream arquivo(nomeArquivo);
    if (!arquivo.is_open()) return false;
    
    arquivo << mapa.nome << "\n";
    arquivo << mapa.largura << " " << mapa.altura << "\n";
    
    for (int i = 0; i < mapa.altura; i++) {
        for (int j = 0; j < mapa.largura; j++) {
            arquivo << mapa.grid[i][j];
        }
        arquivo << "\n";
    }
    
    arquivo.close();
    return true;
}

bool carregarMapa(MapaEstatico& mapa, const char* nomeArquivo) {
    ifstream arquivo(nomeArquivo);
    if (!arquivo.is_open()) return false;
    
    arquivo.getline(mapa.nome, MAX_NOME);
    arquivo >> mapa.largura >> mapa.altura;
    arquivo.ignore(); // Ignora o \n após os números
    
    for (int i = 0; i < mapa.altura; i++) {
        string linha;
        getline(arquivo, linha);
        for (int j = 0; j < mapa.largura && j < linha.length(); j++) {
            mapa.grid[i][j] = linha[j];
        }
    }
    
    arquivo.close();
    return true;
}
```

## Exemplo 5: Editor de Mapas Interativo

```cpp
void editorMapas() {
    MapaEstatico mapa;
    inicializarMapa(mapa, "Editor", 15, 10);
    
    int cursorX = 0, cursorY = 0;
    char elementoAtual = '#';
    
    while (true) {
        system("clear"); // Linux/Mac ou system("cls"); para Windows
        
        // Exibe o mapa com cursor
        for (int i = 0; i < mapa.altura; i++) {
            for (int j = 0; j < mapa.largura; j++) {
                if (i == cursorY && j == cursorX) {
                    cout << "[" << mapa.grid[i][j] << "]";
                } else {
                    cout << " " << mapa.grid[i][j] << " ";
                }
            }
            cout << "\n";
        }
        
        cout << "\nElemento atual: " << elementoAtual << "\n";
        cout << "WASD para mover, ESPAÇO para colocar, Q para sair\n";
        
        char tecla = getchar();
        switch (tecla) {
            case 'w': if (cursorY > 0) cursorY--; break;
            case 's': if (cursorY < mapa.altura - 1) cursorY++; break;
            case 'a': if (cursorX > 0) cursorX--; break;
            case 'd': if (cursorX < mapa.largura - 1) cursorX++; break;
            case ' ': mapa.grid[cursorY][cursorX] = elementoAtual; break;
            case 'q': return;
            case '1': elementoAtual = '.'; break;
            case '2': elementoAtual = '#'; break;
            case '3': elementoAtual = '~'; break;
            case '4': elementoAtual = 'T'; break;
        }
    }
}
```

## Dicas de Performance

### 1. Acesso Eficiente
```cpp
// Bom: acesso direto
char elemento = mapa.grid[linha][coluna];

// Evite: verificações desnecessárias em loops
for (int i = 0; i < mapa.altura; i++) {
    for (int j = 0; j < mapa.largura; j++) {
        // Acesso direto é O(1)
        processar(mapa.grid[i][j]);
    }
}
```

### 2. Cache de Posições
```cpp
struct Posicao {
    int x, y;
};

// Cache posições importantes
Posicao posicaoJogador = {3, 5};
Posicao posicoesTesouros[10];
int numTesouros = 0;
```

### 3. Otimização de Memória
```cpp
// Para mapas pequenos, use tipos menores
typedef unsigned char MapaTile;
MapaTile miniMapa[8][8]; // 64 bytes ao invés de 64 chars
```

## Exercícios Práticos

1. **Básico**: Implemente uma função `contarElementos()` que conta quantos elementos de um tipo existem no mapa.

2. **Intermediário**: Crie um sistema de "fog of war" onde apenas áreas próximas ao jogador são visíveis.

3. **Avançado**: Implemente o algoritmo A* para encontrar o caminho mais curto entre dois pontos.

4. **Expert**: Crie um gerador procedural de dungeons usando algoritmos de cellular automata.

## Recursos Adicionais

- [Algoritmos de Geração Procedural](https://en.wikipedia.org/wiki/Procedural_generation)
- [Pathfinding Algorithms](https://en.wikipedia.org/wiki/Pathfinding)
- [Game Programming Patterns](https://gameprogrammingpatterns.com/)