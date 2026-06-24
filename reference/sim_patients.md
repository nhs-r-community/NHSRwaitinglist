# Generator of NHS patients

Generates simulated NHS patients

## Usage

``` r
sim_patients(n_rows = 10, start_date = NULL)
```

## Arguments

- n_rows:

  Number of rows/patients to generate

- start_date:

  Start date (needed to generate patient ages)

## Value

A data.frame representing an empty waiting list with the following
columns:

- Referral:

  Date. Referral date; all values are `NA`.

- Removal:

  Date. Removal date; all values are `NA`.

- Withdrawal:

  Date. Patient withdrawal date; all values are `NA`

- Priority:

  Numeric. Waiting list priority level, from 1 (most urgent) to 4 (least
  urgent).

- Target_wait:

  Numeric. Target number of days the patient should wait at the assigned
  priority level (e.g., 28 days for priority 2)

- Name:

  Character. Patient name in the format `"Last, First"`.

- Birth_date:

  Date. Date of birth.

- NHS_number:

  Integer. Patient identifier, up to 100,000,000.

- Specialty_code:

  Character. One-letter code representing the specialty of the
  procedure.

- Specialty:

  Character. Full name of the specialty associated with the procedure.

- OPCS:

  Character. OPCS-4 code of the selected procedure.

- Procedure:

  Character. Name of the selected procedure.

- Consultant:

  Character. Consultant name in the format `"Last, First"`.

## Examples

``` r
sim_patients()
#>    Referral Removal Withdrawal Priority Target_wait                 Name
#> 1      <NA>    <NA>       <NA>        4         365      Wheeler, Cierra
#> 2      <NA>    <NA>       <NA>        2          28       Johnson, Jalen
#> 3      <NA>    <NA>       <NA>        1           7       el-Mian, Hamza
#> 4      <NA>    <NA>       <NA>        4         365 Maldonado, Francesco
#> 5      <NA>    <NA>       <NA>        4         365       Wesley, Kaylah
#> 6      <NA>    <NA>       <NA>        4         365       Xiong, Joachim
#> 7      <NA>    <NA>       <NA>        4         365    al-Muhammed, Huda
#> 8      <NA>    <NA>       <NA>        4         365       Rivera, Monica
#> 9      <NA>    <NA>       <NA>        1           7       Reece, Sabrina
#> 10     <NA>    <NA>       <NA>        1           7       Macias, Monica
#>    Birth_date NHS_number Specialty_code
#> 1  2020-09-03   18261270              Z
#> 2  1975-12-13   54583776              B
#> 3  1989-05-11   29667426              N
#> 4  2025-05-04   16295646              V
#> 5  1982-10-06    1818720              X
#> 6  1980-04-22   76107722              N
#> 7  1973-12-08   83179572              C
#> 8  1980-12-04   16168471              B
#> 9  1949-02-05   90652366              Z
#> 10 1987-09-26   17733190              Z
#>                                          Specialty OPCS
#> 1  Subsidiary Classification of Sites of Operation Z562
#> 2                      Endocrine System and Breast B092
#> 3                              Male Genital Organs N159
#> 4              Bones and Joints of Skull and Spine V528
#> 5                         Miscellaneous Operations X842
#> 6                              Male Genital Organs N201
#> 7                                              Eye C331
#> 8                      Endocrine System and Breast B098
#> 9  Subsidiary Classification of Sites of Operation Z033
#> 10 Subsidiary Classification of Sites of Operation Z792
#>                                                        Procedure
#> 1                                            Z56.2 Thenar muscle
#> 2                    B09.2 Excision of sublingual thyroid tissue
#> 3                     N15.9 Unspecified operations on epididymis
#> 4  V52.8 Other specified other operations on intervertebral disc
#> 5                        X84.2 Pulmonary surfactant drugs Band 1
#> 6                     N20.1 Excision of lesion of spermatic cord
#> 7             C33.1 Resection of medial rectus muscle of eye NEC
#> 8    B09.8 Other specified operations on aberrant thyroid tissue
#> 9                                   Z03.3 Oculomotor nerve (iii)
#> 10                                               Z79.2 Os calcis
#>               Consultant
#> 1       Roberts, Michael
#> 2       Nguyen, Benjamin
#> 3   Alvarado Jr, Diamond
#> 4     Barcelona, Shyloah
#> 5        Goodger, Kaylee
#> 6         Runnels, Laura
#> 7  Lemus-Salazar, Kaylee
#> 8            Le, Brandon
#> 9     Buczynski, Timothy
#> 10         Basnet, Kevin
```
