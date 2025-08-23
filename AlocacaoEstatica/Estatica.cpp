#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <map>

using namespace std;

// Estrutura para representar um item de preço estático
struct ItemPreco {
    string descricao;
    double preco;
};

// Classe para calcular preços de e-commerce WordPress/WooCommerce
class CalculadoraEcommerce {
private:
    // Preços base estáticos (alocação estática de preços)
    map<string, ItemPreco> precosBase = {
        {"basico", {"Site básico WordPress + WooCommerce", 1500.0}},
        {"intermediario", {"Site intermediário com customizações", 3000.0}},
        {"avancado", {"Site avançado com funcionalidades complexas", 5500.0}},
        {"premium", {"Site premium com desenvolvimento customizado", 8500.0}}
    };
    
    map<string, ItemPreco> funcionalidadesExtras = {
        {"design_customizado", {"Design customizado", 800.0}},
        {"integracao_pagamento", {"Integração sistemas de pagamento", 400.0}},
        {"gestao_estoque", {"Sistema gestão de estoque", 600.0}},
        {"multiidiomas", {"Suporte multi-idiomas", 500.0}},
        {"seo_otimizado", {"SEO otimizado", 300.0}},
        {"app_mobile", {"Aplicativo mobile", 2000.0}},
        {"integracao_erp", {"Integração com ERP", 1200.0}},
        {"relatorios_avancados", {"Relatórios avançados", 700.0}}
    };
    
    map<int, double> multiplicadorProdutos = {
        {50, 1.0},      // Até 50 produtos
        {200, 1.2},     // 51-200 produtos
        {500, 1.4},     // 201-500 produtos
        {1000, 1.6},    // 501-1000 produtos
        {2000, 1.8}     // 1001-2000 produtos
    };

public:
    void exibirMenu() {
        cout << "\n=== CALCULADORA DE PREÇOS E-COMMERCE ===" << endl;
        cout << "WordPress + WooCommerce" << endl;
        cout << "=======================================" << endl;
    }
    
    void exibirPlanosBase() {
        cout << "\nPlanos base disponíveis:" << endl;
        cout << "1. Básico: R$ " << fixed << setprecision(2) << precosBase["basico"].preco << " - " << precosBase["basico"].descricao << endl;
        cout << "2. Intermediário: R$ " << precosBase["intermediario"].preco << " - " << precosBase["intermediario"].descricao << endl;
        cout << "3. Avançado: R$ " << precosBase["avancado"].preco << " - " << precosBase["avancado"].descricao << endl;
        cout << "4. Premium: R$ " << precosBase["premium"].preco << " - " << precosBase["premium"].descricao << endl;
    }
    
    void exibirFuncionalidadesExtras() {
        cout << "\nFuncionalidades extras disponíveis:" << endl;
        int i = 1;
        for (const auto& func : funcionalidadesExtras) {
            cout << i << ". " << func.second.descricao << " - R$ " << fixed << setprecision(2) << func.second.preco << endl;
            i++;
        }
    }
    
    string selecionarPlanoBase() {
        int opcao;
        cout << "\nSelecione o plano base (1-4): ";
        cin >> opcao;
        
        switch(opcao) {
            case 1: return "basico";
            case 2: return "intermediario";
            case 3: return "avancado";
            case 4: return "premium";
            default: 
                cout << "Opção inválida. Selecionando plano básico." << endl;
                return "basico";
        }
    }
    
    vector<string> selecionarFuncionalidadesExtras() {
        vector<string> selecionadas;
        string continuar = "s";
        
        cout << "\nDeseja adicionar funcionalidades extras? (s/n): ";
        cin >> continuar;
        
        if (continuar == "s" || continuar == "S") {
            cout << "Digite os números das funcionalidades desejadas (separados por espaço, 0 para finalizar):" << endl;
            
            vector<string> chaves;
            for (const auto& func : funcionalidadesExtras) {
                chaves.push_back(func.first);
            }
            
            int opcao;
            while (cin >> opcao && opcao != 0) {
                if (opcao >= 1 && opcao <= chaves.size()) {
                    selecionadas.push_back(chaves[opcao - 1]);
                    cout << "Adicionado: " << funcionalidadesExtras[chaves[opcao - 1]].descricao << endl;
                } else {
                    cout << "Opção inválida: " << opcao << endl;
                }
            }
        }
        
        return selecionadas;
    }
    
    int obterNumeroProdutos() {
        int produtos;
        cout << "\nQuantos produtos terá o e-commerce? ";
        cin >> produtos;
        return produtos;
    }
    
    double calcularMultiplicadorProdutos(int numProdutos) {
        for (const auto& tier : multiplicadorProdutos) {
            if (numProdutos <= tier.first) {
                return tier.second;
            }
        }
        return 2.0; // Para mais de 2000 produtos
    }
    
    void calcularOrcamento() {
        exibirMenu();
        exibirPlanosBase();
        
        string planoBase = selecionarPlanoBase();
        double precoBase = precosBase[planoBase].preco;
        
        exibirFuncionalidadesExtras();
        vector<string> extrasEscolhidas = selecionarFuncionalidadesExtras();
        
        int numProdutos = obterNumeroProdutos();
        double multiplicador = calcularMultiplicadorProdutos(numProdutos);
        
        // Cálculo final
        double precoExtras = 0.0;
        for (const string& extra : extrasEscolhidas) {
            precoExtras += funcionalidadesExtras[extra].preco;
        }
        
        double precoTotal = (precoBase + precoExtras) * multiplicador;
        
        // Exibir orçamento detalhado
        cout << "\n=== ORÇAMENTO DETALHADO ===" << endl;
        cout << "Plano base: " << precosBase[planoBase].descricao << " - R$ " << fixed << setprecision(2) << precoBase << endl;
        
        if (!extrasEscolhidas.empty()) {
            cout << "\nFuncionalidades extras:" << endl;
            for (const string& extra : extrasEscolhidas) {
                cout << "- " << funcionalidadesExtras[extra].descricao << " - R$ " << funcionalidadesExtras[extra].preco << endl;
            }
            cout << "Subtotal extras: R$ " << precoExtras << endl;
        }
        
        cout << "\nNúmero de produtos: " << numProdutos << endl;
        cout << "Multiplicador por complexidade: " << fixed << setprecision(1) << multiplicador << "x" << endl;
        
        cout << "\n=========================" << endl;
        cout << "PREÇO TOTAL: R$ " << fixed << setprecision(2) << precoTotal << endl;
        cout << "=========================" << endl;
        
        // Informações adicionais
        cout << "\nObservações:" << endl;
        cout << "- Preços incluem desenvolvimento e configuração inicial" << endl;
        cout << "- Manutenção mensal: R$ " << (precoTotal * 0.05) << " (5% do valor total)" << endl;
        cout << "- Prazo de entrega: " << (extrasEscolhidas.size() * 5 + 15) << " dias úteis" << endl;
    }
};

int main() {
    cout << "Bem-vindo ao sistema de orçamento para E-commerce!" << endl;
    cout << "Este sistema utiliza alocação estática de preços para WordPress + WooCommerce" << endl;
    
    CalculadoraEcommerce calculadora;
    
    char continuar = 's';
    while (continuar == 's' || continuar == 'S') {
        calculadora.calcularOrcamento();
        
        cout << "\nDeseja fazer outro orçamento? (s/n): ";
        cin >> continuar;
    }
    
    cout << "\nObrigado por usar nosso sistema de orçamento!" << endl;
    
    return 0;
}