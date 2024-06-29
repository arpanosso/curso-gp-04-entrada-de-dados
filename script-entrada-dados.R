# Entrada de dados txt
# Encontrando arquivos
list.files("data-raw") # arquivos e pastas

list.files("data-raw",
           full.names = TRUE) # nomes completos

list.files("data-raw",
           full.names = TRUE,
           recursive = TRUE) # todos os arquivos

# buscando somente arquivos .txt
list.files("data-raw",
           full.names = TRUE,
           recursive = TRUE,
           pattern = ".txt")

# Entrando com arquivo .txt
raiz <- read.table("data-raw/biomassaRad.txt",
                   h = TRUE, # primeira linha é cabeçalho
                   sep = "\t", # separador de colunas é a tabulação
                   dec = ".") # separador decimal

# Entrando com arquivos .xlsx
# 1) Instalar pacote {readxl}
# 2) Acessar:
##   - Packages/Install/Procurar pelo nome do pacote/Install

# Carregando um pacote
library(readxl)
anomalia <- read_xlsx("data-raw/anomalias_classes.xlsx")

# Padrão ouro de leitura de arquivos
# o pacote é o {tidyverse}
library(tidyverse)

# Lendo um único arquivo csv
read_csv("data-raw/CSV/OCO2L2Stdv10_L3_20141001_000000_20141031_235959.csv")

# Para ler e empilhar, vamos utilizar a função map do pacote
# {purrr} que faz múltiplas aplicações de uma função em
# uma lista de argumentos dessa função.
# Vamos salvar a lista dos nomes dos arquivos .csv presentes
# na pasta data-raw.
my_list <- list.files("data-raw",
                      full.names = TRUE,
                      recursive = TRUE,
                      pattern = ".csv")

# Vamos aplicar a função read_csv.
map(my_list, read.csv) # retorna lista

# Nesse caso usamos a função map_df para empilhar os arquivos
# ao invés de apenas ler e salvar em uma lista

map_df(my_list, read.csv) # retorna um data-frame

# O problema está parcialmente resolvido pois,
# apesar de empilhados, os dados não tem informação de qual
# arquivo eles vieram.
# Para rsolver o problema vamos "mascarar" a função readr
# fazendo com que os dados resultantes carreguem uma coluna
# com o nome dos arquivos.
my_reader <- function(path){
  read_csv(path) %>%
    mutate(caminho = path)
}

#vamos aplicar a map_df à função my_reader
dados <- map_df(my_list,
                my_reader)
dados
# observe agora que dados apresenta 12313 observações
