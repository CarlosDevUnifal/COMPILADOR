%{
    #include "stdio.h"
    #include "stdlib.h"
    #include "string.h"

    #include "lexico.c"
    #include "utils.c"

    int contaVar = 0;
    int rotulo = 0;
    int ehRegistro = 0;
    int tipo;
%}

%token T_DEF
%token T_REGISTRO
%token T_FIMDEF
%token T_IDPONTO

%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_IDENTIF
%token T_LEIA
%token T_ESCREVA
%token T_ENQTO
%token T_FACA
%token T_ENTAO
%token T_FIMENQTO
%token T_SE
%token T_SENAO
%token T_FIMSE
%token T_ATRIB
%token T_VEZES
%token T_DIV
%token T_MAIS
%token T_MENOS
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_E
%token T_OU
%token T_V
%token T_F
%token T_NUMERO
%token T_NAO
%token T_ABRE
%token T_FECHA
%token T_LOGICO
%token T_INTEIRO

%start programa 

%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%

programa
    : cabecalho define_registro variaveis 
        { 
            mostraTabela();
            empilha(contaVar);
            if(contaVar)
                fprintf(yyout, "\tAMEM\t%d\n", contaVar); 
        }
    T_INICIO lista_comandos T_FIM
        { 
            int conta = desempilha();
            if(conta)
                fprintf(yyout, "\tDMEM\t%d\n", conta);
        }
        {   fprintf(yyout, "\tFIMP\n"); }
    ;

cabecalho
    : T_PROGRAMA T_IDENTIF
        { fprintf(yyout, "\tINPP\n"); }
    ;

tipo
    : T_LOGICO
        {tipo = LOG;}
    | T_INTEIRO
        { tipo = INT;} 
    | T_REGISTRO T_IDENTIF
        { tipo = REG;}
    ;

define_registro
    : define define_registro
    | 
    ;

define
    : T_DEF definicao_campos T_FIMDEF T_IDENTIF
        {
            strcpy(elemTab.id, atomo);
            elemTab.end = -1; // Endereço para registros pode ser definido como -1
            elemTab.tip = REG;
            // Adicionar lógica para tratar os campos do registro
            insereSimbolo(elemTab);
        }
    ;

definicao_campos
    : tipo lista_campos definicao_campos
    | tipo lista_campos
    ;
lista_campos
    : lista_campos T_IDENTIF
    | T_IDENTIF
        {
            int deslocamento = 0;
            if (elemTab.tip == REG) {
                // Calcula o deslocamento com base nos campos anteriores
                CampoReg *campoAtual = elemTab.campos;
                while (campoAtual != NULL) {
                    deslocamento += campoAtual->tam; // Supondo que 'tam' já foi definido
                    campoAtual = campoAtual->prox;
                }
            }

            int tamanho = 1; // Exemplo para tipos INT e LOG
            // Para REG, seria necessário calcular com base nos campos do registro

            // Inserir o campo no registro
            insereCampo(&(elemTab.campos), atomo, tipo, deslocamento, tamanho, posTab);
        }
    ;



variaveis
    : /*vazio*/
    | declaracao_variaveis
    ;

declaracao_variaveis
    : tipo lista_variaveis declaracao_variaveis
    | tipo lista_variaveis
    ;

lista_variaveis
    : lista_variaveis 
    T_IDENTIF
        { 
            strcpy(elemTab.id, atomo);
            elemTab.end = contaVar;
            elemTab.tip = tipo;
            insereSimbolo (elemTab);
            contaVar++; 

        } 
    
    | T_IDENTIF
        { 
            strcpy(elemTab.id, atomo);
            elemTab.end = contaVar;
            elemTab.tip = tipo;
            insereSimbolo (elemTab);
            contaVar++; 
        } 
    ;

lista_comandos
    : /* vazio */
    | comando lista_comandos
    ;

comando
    : entrada_saida
    | atribuicao
    | selecao
    | repeticao
    ;

entrada_saida
    : entrada
    | saida 
    ;

entrada
    : T_LEIA T_IDENTIF
        {   
            int pos = buscaSimbolo(atomo);
            fprintf(yyout, "\tLEIA\n"); 
            fprintf(yyout, "\tARZG\t%d\n", tabSimb[pos].end); 
        }
    ;

saida
    : T_ESCREVA expressao
        { 
            desempilha();
            fprintf(yyout, "\tESCR\n"); 
        }

    ;

atribuicao
    : expressao_acesso 
        { 
            int pos = buscaSimbolo(atomo);
            empilha(pos);
        }
    T_ATRIB expressao
        { 
            int tip = desempilha();
            int pos = desempilha();
            if(tabSimb[pos].tip != tip)
                yyerror("Incompatibilidade de tipo!");
            fprintf(yyout, "\tARZG\t%d\n", tabSimb[pos].end); 
        }
    ;

selecao
    : T_SE expressao T_ENTAO
        { 
            int t = desempilha();
            if(t != LOG)
                yyerror("Incompatibilidade de tipo!");
            fprintf(yyout, "\tDSVF\tL%d\n", ++rotulo);
            empilha(rotulo); 
        }
     lista_comandos T_SENAO 
        { 
            fprintf(yyout, "\tDSVS\tL%d\n", ++rotulo);
            int rot = desempilha();
            fprintf(yyout, "L%d\tNADA\n", rot); 
            empilha(rotulo);
        }
     lista_comandos T_FIMSE
        { 
            int rot = desempilha();
            fprintf(yyout, "L%d\tNADA\n", rot); 
        }
    ;

repeticao
    : T_ENQTO 
        { 
            fprintf(yyout, "L%d\tNADA\n",++rotulo); 
            empilha(rotulo);
        }
     expressao T_FACA
        { 
            int t = desempilha();
            if(t != LOG)
                yyerror("Incompatibilidade de tipo");
            fprintf(yyout, "\tDSVF\tL%d\n", ++rotulo); 
            empilha(rotulo);
        }
        
     lista_comandos T_FIMENQTO
        { 
            int rot1 = desempilha();
            int rot2 = desempilha();
            fprintf(yyout, "\tDSVS\tL%d\n", rot2); 
            fprintf(yyout, "L%d\tNADA\n", rot1); 
        }
    ;

expressao
    : expressao T_VEZES expressao
        { 
            testaTipo(INT,INT,INT);
            fprintf(yyout, "\tMULT\n"); 
        }
    | expressao T_DIV expressao
        { 
            testaTipo(INT,INT,INT);
            fprintf(yyout, "\tDIVI\n"); 
        }
    | expressao T_MAIS expressao
        { 
            testaTipo(INT,INT,INT);
            fprintf(yyout, "\tSOMA\n"); 
        }
    | expressao T_MENOS expressao
        { 
            testaTipo(INT,INT,INT);
            fprintf(yyout, "\tSUBT\n"); 
        }
    | expressao T_MAIOR expressao
        {
            testaTipo(INT,INT,LOG);
            fprintf(yyout, "\tCMMA\n"); 
        }
    | expressao T_MENOR expressao
        { 
            testaTipo(INT,INT,LOG);
            fprintf(yyout, "\tCMME\n"); 
        }
    | expressao T_IGUAL expressao
        { 
            testaTipo(INT,INT,LOG);
            fprintf(yyout, "\tCMIG\n"); 
        }
    | expressao T_E expressao
        { 
            testaTipo(LOG,LOG,LOG);
            fprintf(yyout, "\tCONJ\n"); 
        }
    | expressao T_OU expressao
        { 
            testaTipo(LOG,LOG,LOG);
            fprintf(yyout, "\tDISJ\n"); 
        }
    | termo
    ;

expressao_acesso
    : T_IDENTIF
        { 
            if(ehRegistro){
                empilha(REG);
            }
            else {
                int pos = buscaSimbolo(atomo);
                fprintf(yyout, "\tCRVG\t%d\n", tabSimb[pos].end); 
                empilha(tabSimb[pos].tip);
                
            }
            ehRegistro = 0;
        }
    | T_IDPONTO 
        {
            if (!ehRegistro)
                ehRegistro = 1;
        }
    expressao_acesso
    ;

termo
    : expressao_acesso
    | T_NUMERO
        { 
            fprintf(yyout, "\tCRCT\t%s\n", atomo); 
            empilha(INT);
        }
    | T_V
        { 
            fprintf(yyout, "\tCRCT\t1\n"); 
            empilha(LOG);
        }
    | T_F
        { 
            fprintf(yyout, "\tCRCT\t0\n"); 
            empilha(LOG);
            
        }
    | T_NAO termo
        { 
            int t = desempilha();
            if(t != LOG)
                yyerror("Incompatibilidade de tipo!");
            fprintf(yyout, "\tNEGA\n"); 
            empilha(LOG);
            
        }
    | T_ABRE expressao T_FECHA
    ;
%%

int main(int argc, char *argv[]){
    char *p, nameIn[100], nameOut[100];
    argv++;
    if(argc < 2){
        puts("\n Compilador da linguagem SIMPLES");
        puts(" \n\t USO: ./simples <NOME>[.simples]\n\n");
        exit(1);
    }
    p = strstr(argv[0], ".simples");
    if (p) *p = 0;
    strcpy(nameIn, argv[0]);
    strcat(nameIn, ".simples");
    strcpy(nameOut, argv[0]);
    strcat(nameOut, ".mvs");

    yyin = fopen(nameIn, "rt");
    if(!yyin){
        puts("Programa fonte nao encontrado!");
        exit(2);
    }

    yyout = fopen(nameOut, "wt");
    yyparse();
    printf("programa OK!\n\n");
    return 0;
}