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


#obtendo informações dos objetos

#opção 1 - usando a funçao str
str(raiz)

#opção 2 - usando a funçao glimpse
glimpse(raiz)

#opção 3 - usando a funçao skim
skimr::skim(raiz)

#propriedades do objeto
#numero de linhas
nrow(raiz)

#numero de colunas
ncol(raiz)
length(raiz) #somente em dataframes

class(raiz) #tipo do arquivo
mode(raiz) #tipo dos dados
typeof(raiz) #tipo dos dados

#convertendo arquivo dataframe para uma tibble
raiz
head(raiz) #mostra o inicio do banco de dados
tail(raiz) #mostra o final do banco de dados

#convertendo para tibble
as_tibble(raiz)
raiz <- as_tibble(raiz)

#buscando os dados do objeto raiz
#extraindo os dados de biomassa
raiz$biomassa_raizes
hist(raiz$biomassa_raizes)

#vamos criar o histograma utilizando o PIPE
raiz %>%
  pull(biomassa_raizes) %>%
  boxplot()

#quantos valores unicos de tratamentos nos temos
raiz %>%
  pull(tratamento) %>%
  unique()

#quantos valores unicos de ciclos nos temos
raiz %>%
  pull(ciclo) %>%
  unique()

#um boxplot com ciclos e biomassa das raizes
raiz %>%
  mutate(ciclo = as_factor(ciclo)) %>%
  ggplot(aes(x = ciclo, y = biomassa_raizes)) +
  geom_boxplot(fill = "blue")

#boxplot com ciclos mapeados nas cores
raiz %>%
  mutate(ciclo = as_factor(ciclo)) %>%
  ggplot(aes(x = ciclo, y = biomassa_raizes,
             fill = ciclo)) +
  geom_boxplot() +
  theme_bw() +
  labs(x = "Anos de cultivo",
       y = "Biomassa (gramas)") +
  theme(legend.position = "top") + # "" tira legenda
  scale_fill_viridis_d(option = "magma") #viridis é inclusiva para daltonicos

#vamos fazer um histograma para o ciclo 2
vetor_cores <- c("salmon","aquamarine4","purple")
raiz %>%
  filter(ciclo == 2) %>%
  ggplot(aes(x = biomassa_raizes, fill = bloco)) +
  geom_histogram(bins = 10,
               # fill = "aquamarine4",
                 color = "black") +
  facet_wrap(~bloco) +
  theme_bw() +
  theme(legend.position = "") +
  scale_fill_manual(values = vetor_cores) +
  theme(
    axis.title.x = element_text(size = rel(1.5)),
    axis.title.y = element_text(size = rel(1.5)),
  )

#construir um histograma para o ciclo 4 mapeando
#o tratamento nas cores, somente para pd

raiz %>%
  filter(ciclo == 4,
         str_detect(tratamento,"pd")) %>%
  ggplot(aes(x = biomassa_raizes,
             fill = tratamento)) +
  geom_histogram(bins = 7, position = "dodge") +
  labs(fill = "")






































































