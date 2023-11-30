/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_SINTATICO_H_INCLUDED
# define YY_YY_SINTATICO_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    T_DEF = 258,                   /* T_DEF  */
    T_REGISTRO = 259,              /* T_REGISTRO  */
    T_FIMDEF = 260,                /* T_FIMDEF  */
    T_IDPONTO = 261,               /* T_IDPONTO  */
    T_PROGRAMA = 262,              /* T_PROGRAMA  */
    T_INICIO = 263,                /* T_INICIO  */
    T_FIM = 264,                   /* T_FIM  */
    T_IDENTIF = 265,               /* T_IDENTIF  */
    T_LEIA = 266,                  /* T_LEIA  */
    T_ESCREVA = 267,               /* T_ESCREVA  */
    T_ENQTO = 268,                 /* T_ENQTO  */
    T_FACA = 269,                  /* T_FACA  */
    T_ENTAO = 270,                 /* T_ENTAO  */
    T_FIMENQTO = 271,              /* T_FIMENQTO  */
    T_SE = 272,                    /* T_SE  */
    T_SENAO = 273,                 /* T_SENAO  */
    T_FIMSE = 274,                 /* T_FIMSE  */
    T_ATRIB = 275,                 /* T_ATRIB  */
    T_VEZES = 276,                 /* T_VEZES  */
    T_DIV = 277,                   /* T_DIV  */
    T_MAIS = 278,                  /* T_MAIS  */
    T_MENOS = 279,                 /* T_MENOS  */
    T_MAIOR = 280,                 /* T_MAIOR  */
    T_MENOR = 281,                 /* T_MENOR  */
    T_IGUAL = 282,                 /* T_IGUAL  */
    T_E = 283,                     /* T_E  */
    T_OU = 284,                    /* T_OU  */
    T_V = 285,                     /* T_V  */
    T_F = 286,                     /* T_F  */
    T_NUMERO = 287,                /* T_NUMERO  */
    T_NAO = 288,                   /* T_NAO  */
    T_ABRE = 289,                  /* T_ABRE  */
    T_FECHA = 290,                 /* T_FECHA  */
    T_LOGICO = 291,                /* T_LOGICO  */
    T_INTEIRO = 292                /* T_INTEIRO  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_SINTATICO_H_INCLUDED  */
