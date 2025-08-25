#include <iostream>
#include <iomanip>
#include <cstring>

using namespace std;

// Constantes para definir o tamanho máximo dos mapas
const int MAX_LINHAS = 20;
const int MAX_COLUNAS = 30;
const int MAX_NOME = 50;

// Estrutura para representar um mapa usando alocação estática
struct MapaEstatico {
    char nome[MAX_NOME];
    int largura;
    int altura;
    char grid[MAX_LINHAS][MAX_COLUNAS];
    char legenda[256][50]; // Para diferentes tipos de terreno
};

// Função para inicializar um mapa vazio
void inicializarMapa(MapaEstatico& mapa, const char* nome, int largura, int altura) {
    // Copia o nome do mapa
    strncpy(mapa.nome, nome, MAX_NOME - 1);
    mapa.nome[MAX_NOME - 1] = '\0';
    
    mapa.largura = (largura > MAX_COLUNAS) ? MAX_COLUNAS : largura;
    mapa.altura = (altura > MAX_LINHAS) ? MAX_LINHAS : altura;
    
    // Inicializa o grid com espaços vazios
    for (int i = 0; i < MAX_LINHAS; i++) {
        for (int j = 0; j < MAX_COLUNAS; j++) {
            if (i < mapa.altura && j < mapa.largura) {
                mapa.grid[i][j] = '.'; // Terreno vazio
            } else {
                mapa.grid[i][j] = '\0';
            }
        }
    }
    
    // Inicializa a legenda
    strcpy(mapa.legenda['.'], "Terreno vazio");
    strcpy(mapa.legenda['#'], "Parede/Obstáculo");
    strcpy(mapa.legenda['~'], "Água");
    strcpy(mapa.legenda['^'], "Montanha");
    strcpy(mapa.legenda['T'], "Árvore");
    strcpy(mapa.legenda['P'], "Jogador");
    strcpy(mapa.legenda['E'], "Inimigo");
    strcpy(mapa.legenda['$'], "Tesouro");
}

// Função para exibir um mapa
void exibirMapa(const MapaEstatico& mapa) {
    cout << "\n========================================\n";
    cout << "Mapa: " << mapa.nome << "\n";
    cout << "Dimensões: " << mapa.largura << "x" << mapa.altura << "\n";
    cout << "========================================\n";
    
    // Exibe números das colunas
    cout << "   ";
    for (int j = 0; j < mapa.largura; j++) {
        cout << setw(2) << j;
    }
    cout << "\n";
    
    // Exibe o grid com números das linhas
    for (int i = 0; i < mapa.altura; i++) {
        cout << setw(2) << i << " ";
        for (int j = 0; j < mapa.largura; j++) {
            cout << mapa.grid[i][j] << " ";
        }
        cout << "\n";
    }
    cout << "\n";
}

// Função para adicionar um elemento no mapa
bool adicionarElemento(MapaEstatico& mapa, int linha, int coluna, char elemento) {
    if (linha >= 0 && linha < mapa.altura && coluna >= 0 && coluna < mapa.largura) {
        mapa.grid[linha][coluna] = elemento;
        return true;
    }
    return false;
}

// Função para criar bordas no mapa
void criarBordas(MapaEstatico& mapa) {
    // Bordas horizontais
    for (int j = 0; j < mapa.largura; j++) {
        mapa.grid[0][j] = '#';
        mapa.grid[mapa.altura - 1][j] = '#';
    }
    
    // Bordas verticais
    for (int i = 0; i < mapa.altura; i++) {
        mapa.grid[i][0] = '#';
        mapa.grid[i][mapa.largura - 1] = '#';
    }
}

// Função para criar um labirinto simples
void criarLabirinto(MapaEstatico& mapa) {
    // Primeiro, cria bordas
    criarBordas(mapa);
    
    // Adiciona algumas paredes internas
    for (int i = 2; i < mapa.altura - 2; i += 2) {
        for (int j = 2; j < mapa.largura - 2; j += 3) {
            mapa.grid[i][j] = '#';
        }
    }
    
    // Adiciona entrada e saída
    if (mapa.altura > 2) {
        mapa.grid[1][0] = '.'; // Entrada
        mapa.grid[mapa.altura - 2][mapa.largura - 1] = '.'; // Saída
    }
}

// Função para criar um mapa de ilha
void criarIlha(MapaEstatico& mapa) {
    // Preenche tudo com água
    for (int i = 0; i < mapa.altura; i++) {
        for (int j = 0; j < mapa.largura; j++) {
            mapa.grid[i][j] = '~';
        }
    }
    
    // Cria uma ilha no centro
    int centroX = mapa.largura / 2;
    int centroY = mapa.altura / 2;
    int raio = min(mapa.largura, mapa.altura) / 4;
    
    for (int i = centroY - raio; i <= centroY + raio; i++) {
        for (int j = centroX - raio; j <= centroX + raio; j++) {
            if (i >= 0 && i < mapa.altura && j >= 0 && j < mapa.largura) {
                // Verifica se está dentro do círculo (aproximadamente)
                int dx = j - centroX;
                int dy = i - centroY;
                if (dx * dx + dy * dy <= raio * raio) {
                    mapa.grid[i][j] = '.';
                    
                    // Adiciona algumas árvores
                    if ((i + j) % 3 == 0) {
                        mapa.grid[i][j] = 'T';
                    }
                }
            }
        }
    }
    
    // Adiciona algumas montanhas no centro
    if (centroY >= 0 && centroY < mapa.altura && centroX >= 0 && centroX < mapa.largura) {
        mapa.grid[centroY][centroX] = '^';
        if (centroY + 1 < mapa.altura) mapa.grid[centroY + 1][centroX] = '^';
        if (centroX + 1 < mapa.largura) mapa.grid[centroY][centroX + 1] = '^';
    }
}

// Função para exibir a legenda
void exibirLegenda(const MapaEstatico& mapa) {
    cout << "LEGENDA:\n";
    cout << "========\n";
    cout << ". - " << mapa.legenda['.'] << "\n";
    cout << "# - " << mapa.legenda['#'] << "\n";
    cout << "~ - " << mapa.legenda['~'] << "\n";
    cout << "^ - " << mapa.legenda['^'] << "\n";
    cout << "T - " << mapa.legenda['T'] << "\n";
    cout << "P - " << mapa.legenda['P'] << "\n";
    cout << "E - " << mapa.legenda['E'] << "\n";
    cout << "$ - " << mapa.legenda['$'] << "\n";
    cout << "\n";
}

// Função para demonstrar diferentes tipos de mapas
void demonstrarMapas() {
    cout << "==============================================\n";
    cout << "COMO CONSTRUIR MAPAS USANDO ALOCAÇÃO ESTÁTICA\n";
    cout << "==============================================\n\n";
    
    cout << "Este programa demonstra como construir diferentes tipos de mapas\n";
    cout << "usando alocação estática em C++. Os mapas são armazenados em\n";
    cout << "arrays bidimensionais com tamanho fixo definido em tempo de compilação.\n\n";
    
    // Cria diferentes tipos de mapas
    MapaEstatico mapa1, mapa2, mapa3;
    
    // Mapa 1: Básico com elementos manuais
    inicializarMapa(mapa1, "Mapa Básico", 15, 10);
    adicionarElemento(mapa1, 2, 3, 'P'); // Jogador
    adicionarElemento(mapa1, 5, 8, 'E'); // Inimigo
    adicionarElemento(mapa1, 7, 12, '$'); // Tesouro
    adicionarElemento(mapa1, 3, 6, 'T'); // Árvore
    
    // Mapa 2: Labirinto
    inicializarMapa(mapa2, "Labirinto", 20, 12);
    criarLabirinto(mapa2);
    adicionarElemento(mapa2, 1, 1, 'P'); // Jogador na entrada
    adicionarElemento(mapa2, mapa2.altura - 2, mapa2.largura - 2, '$'); // Tesouro na saída
    
    // Mapa 3: Ilha
    inicializarMapa(mapa3, "Ilha do Tesouro", 18, 14);
    criarIlha(mapa3);
    adicionarElemento(mapa3, mapa3.altura/2 + 2, mapa3.largura/2 + 2, '$'); // Tesouro
    
    // Exibe todos os mapas
    exibirLegenda(mapa1);
    
    exibirMapa(mapa1);
    exibirMapa(mapa2);
    exibirMapa(mapa3);
    
    cout << "Características da Alocação Estática para Mapas:\n";
    cout << "================================================\n";
    cout << "• Tamanho fixo definido em tempo de compilação\n";
    cout << "• Acesso rápido aos elementos O(1)\n";
    cout << "• Memória alocada na stack (mais rápida)\n";
    cout << "• Ideal para mapas de tamanho conhecido\n";
    cout << "• Não há necessidade de gerenciamento manual de memória\n\n";
}

int main() {
    demonstrarMapas();
    
    cout << "Pressione Enter para continuar...";
    cin.get();
    
    return 0;
}