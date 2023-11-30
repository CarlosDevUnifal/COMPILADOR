#include <stdio.h>
#include <string.h>

// Tabela de simbolos

#define TAM_TAB 100

typedef struct campoReg {
    char nomeCampo[100]; // Nome do campo
    int tipoCampo;       // Tipo do campo (INT, LOG, REG)
    int deslocamento;    // Deslocamento do campo no registro
    int tam;             // Tamanho do campo
    int pos;             // Posição do campo na tabela de símbolos
    struct campoReg *prox; // Próximo campo
} CampoReg;



//acrescentar campos na tabela
struct elemTabSimbolos {
    char id[100];   // nome do identificador
    int end;        // endereco
    int tip;        // tipo
    int tam;        // tamanho
    int pos;        // posicao
    int deslocamento;
    CampoReg *campos; // Lista de campos para registros
} tabSimb[TAM_TAB], elemTab;

enum{
    INT,
    LOG,
    REG
};

//Duas modificações, duas rotinas: inserir na lista encadeada, e percorrer a lista.

// criar uma estrutura e operações para manipular uma lista de campos

char nomeTipo[3][4] = {"INT", "LOG", "REG"};

int posTab = 0; // indica a proxima posicao livre para inserir

int buscaSimbolo (char *s){
    int i;
    for (i = posTab - 1; strcmp(tabSimb[i].id, s) && i >= 0; i--); // strcmp(tabSimb[i].id, s) se for igual é true (1) false (0) e para

    if(i == -1){
        char msg[200];
        sprintf(msg, "Identificador [%s] não encontrado!", s);
        yyerror(msg);
    }
    return i;
}

void insereSimbolo(struct elemTabSimbolos elem) {
    if (posTab >= TAM_TAB) {
        yyerror("Tabela de símbolos cheia");
        return;
    }
    
    tabSimb[posTab] = elem;
    posTab++;
}

void insereCampo(CampoReg **lista, char *nome, int tipo, int deslocamento, int tam, int pos) {
    CampoReg *novoCampo = (CampoReg *)malloc(sizeof(CampoReg));
    strcpy(novoCampo->nomeCampo, nome);
    novoCampo->tipoCampo = tipo;
    novoCampo->deslocamento = deslocamento;
    novoCampo->tam = tam;
    novoCampo->pos = pos;
    novoCampo->prox = *lista;
    *lista = novoCampo;
}

void insereRegistroESeusCampos(char *nomeRegistro, CampoReg *campos) {
    // Insere o registro
    strcpy(elemTab.id, nomeRegistro);
    elemTab.end = -1;
    elemTab.tip = REG;
    elemTab.tam = 0; // Calculado com base nos campos
    elemTab.pos = posTab;
    insereSimbolo(elemTab);

    int deslocamentoAtual = 0;
    while (campos != NULL) {
        // Insere cada campo como uma entrada separada
        strcpy(elemTab.id, campos->nomeCampo);
        elemTab.end = posTab; // Endereço do campo é a posição atual
        elemTab.tip = campos->tipoCampo;
        elemTab.tam = 1; // Supondo tamanho 1 para INT e LOG
        elemTab.deslocamento = deslocamentoAtual; // Deslocamento do campo no registro
        insereSimbolo(elemTab);

        deslocamentoAtual += elemTab.tam; // Atualiza o deslocamento
        campos = campos->prox;
    }

    // Atualiza o tamanho total do registro
    tabSimb[elemTab.pos].tam = deslocamentoAtual;
}

void mostraTabela() {
    printf("\n-----------------------TABELA DE SIMBOLOS------------------------\n");
    printf("        ID | END | TIP | TAM | POS | CAMPOS \n");
    printf("-----------------------------------------------------------------\n");
    for (int i = 0; i < posTab; i++) {
        printf("%10s | %3d | %3s | %3d | %3d |",
            tabSimb[i].id, tabSimb[i].end, nomeTipo[tabSimb[i].tip], tabSimb[i].tam, tabSimb[i].pos);

        if (tabSimb[i].tip == REG && tabSimb[i].campos != NULL) {
            CampoReg *campoAtual = tabSimb[i].campos;
            while (campoAtual) {
                printf(" (%s,%s,%d,%d,%d)=>",
                    campoAtual->nomeCampo, nomeTipo[campoAtual->tipoCampo],
                    campoAtual->deslocamento, campoAtual->tam, campoAtual->pos);
                campoAtual = campoAtual->prox;
            }
        }
        printf("\n");
    }
    printf("-----------------------------------------------------------------\n");
}

// Pilha semantica
#define TAM_PILHA 100

int pilha[TAM_PILHA];
int topo = -1;

void empilha (int valor){
    if(topo == TAM_PILHA)
        yyerror ("Pilha semantica cheia!");

    pilha[++topo] = valor;
}

int desempilha (){
    if (topo == -1)
        yyerror("Pilha vazia!");
    return pilha[topo--];
}

// tipo1 e tipo2 são os tipos esperados na expressão 
// ret é o tipo que será empilhado com resultado da expressão

void testaTipo (int tipo1, int tipo2, int ret){
    int t1 = desempilha();
    int t2 = desempilha();
    if (t1 != tipo1 || t2 != tipo2)
        yyerror("Incompatibilidade de tipo!");
    empilha(ret);
}