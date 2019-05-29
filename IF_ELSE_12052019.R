## Fungsi keanggotaan fuzzy
### Dirancang oleh: Felliks F Tampinongkol - Ilkom2016 (IPB)
Fungsi_Linear_Naik <- function(nilai, b_bawah, b_atas){
  a <- (nilai - b_bawah) / (b_atas - b_bawah)
  if(a > 1 | a < 0){sprintf("%f", NA)} 
  else if (a == 0) {sprintf("%f", a)}
  else {sprintf("%f", a)}
}

Fungsi_Linear_Turun <- function(nilai, b_bawah, b_atas){
  a <- (b_atas - nilai) / (b_atas - b_bawah)
  if(a > 1 | a < 0){sprintf("%f", NA)} 
  else if (a == 0) {sprintf("%f", a)}
  else {sprintf("%f", a)}
}

## Test function
nilai_1 <- 13
b_bawah <- 15
b_atas <- 30

f_naik <- Fungsi_Linear_Naik(nilai_1, b_bawah, b_atas)
f_naik

f_turun <- Fungsi_Linear_Turun(nilai_1, b_bawah, b_atas)
f_turun