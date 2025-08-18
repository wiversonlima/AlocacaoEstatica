#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

// Funcao para simular a funcao SE (IF) do Google Sheets
string funcaoSE(bool condicao, const string& verdadeiro, const string& falso) {
    return condicao ? verdadeiro : falso;
}

// Funcao para validar sintaxe de formula do Google Sheets
bool validarSintaxeFormula(const string& formula) {
    // Verifica se usa vírgulas em vez de ponto e vírgula
    size_t posVirgula = formula.find(",");
    size_t posPontoVirgula = formula.find(";");
    
    // Sintaxe correta: deve ter vírgulas e não deve ter ponto e vírgula entre os argumentos
    return (posVirgula != string::npos && posPontoVirgula == string::npos);
}

int main() {
    cout << "=== ANALISE DE FORMULA GOOGLE SHEETS ===" << endl;
    cout << "Problema: =SE(C2>90%,\"a\";\"b\")" << endl << endl;
    
    // Demonstrar o erro  
    string formulaIncorreta = "=SE(C2>90%,\"a\";\"b\")";
    string formulaCorreta = "=SE(C2>90%,\"a\",\"b\")";
    
    cout << "FORMULA INCORRETA: " << formulaIncorreta << endl;
    cout << "Erro: Uso de ponto e vírgula (;) como separador" << endl;
    cout << "Válida: " << (validarSintaxeFormula(formulaIncorreta) ? "SIM" : "NAO") << endl << endl;
    
    cout << "FORMULA CORRETA: " << formulaCorreta << endl;
    cout << "Correção: Uso de vírgula (,) como separador" << endl;
    cout << "Válida: " << (validarSintaxeFormula(formulaCorreta) ? "SIM" : "NAO") << endl << endl;
    
    // Demonstrar a lógica da função SE
    cout << "=== SIMULACAO DA FUNCAO SE ===" << endl;
    
    // Simular diferentes valores para C2
    double valores[] = {85.5, 90.0, 95.2, 88.7, 92.1};
    int numValores = sizeof(valores) / sizeof(valores[0]);
    
    cout << fixed << setprecision(1);
    cout << "Valor C2\t| C2>90%\t| Resultado" << endl;
    cout << "--------\t| ------\t| ---------" << endl;
    
    for (int i = 0; i < numValores; i++) {
        double valor = valores[i];
        bool condicao = valor > 90.0;
        string resultado = funcaoSE(condicao, "a", "b");
        
        cout << valor << "%\t\t| " << (condicao ? "TRUE" : "FALSE") << "\t\t| " << resultado << endl;
    }
    
    cout << endl << "=== RESUMO DO ERRO ===" << endl;
    cout << "O erro na formula =SE(C2>90%,\"a\";\"b\") é o uso de:" << endl;
    cout << "• Ponto e vírgula (;) como separador entre argumentos" << endl;
    cout << "• No Google Sheets, deve-se usar vírgula (,)" << endl;
    cout << "• Formula correta: =SE(C2>90%,\"a\",\"b\")" << endl;
    
    return 0;
}