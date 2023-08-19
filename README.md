
<!-- README.md is generated from README.Rmd. Please edit that file -->

# naturalstattrick

<!-- badges: start -->

[![R-CMD-check](https://github.com/pbulsink/naturalstattrick/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pbulsink/naturalstattrick/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/pbulsink/naturalstattrick/graph/badge.svg?token=1eceI2f2pK)](https://codecov.io/gh/pbulsink/naturalstattrick)
<!-- badges: end -->

The goal of naturalstattrick is to provide a convenient and basic
interface to game-level Natural Stat Trick data.

## Installation

You can install the development version of naturalstattrick from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("pbulsink/naturalstattrick")
```

## Usage

Get a game’s results by calling:

``` r
get_game_report(season = 20222023, game_id = 20041)
#> $tall
#> # A tibble: 8 × 25
#>   team    period toi      cf    ca cf_percent    ff    fa ff_percent    sf    sa
#>   <chr>   <chr>  <chr> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
#> 1 Bruins  1      20:00    24    15      0.615    15    11      0.577    12    11
#> 2 Bruins  2      20:00    18    24      0.429    11    17      0.393     9    10
#> 3 Bruins  3      20:00    24    39      0.381    21    28      0.429    13    20
#> 4 Bruins  Final  60:00    66    78      0.458    47    56      0.456    34    41
#> 5 Panthe… 1      20:00    15    24      0.385    11    15      0.423    11    12
#> 6 Panthe… 2      20:00    24    18      0.571    17    11      0.607    10     9
#> 7 Panthe… 3      20:00    39    24      0.619    28    21      0.571    20    13
#> 8 Panthe… Final  60:00    78    66      0.542    56    47      0.544    41    34
#> # ℹ 14 more variables: sf_percent <dbl>, scf <dbl>, sca <dbl>,
#> #   scf_percent <dbl>, hdcf <dbl>, hdca <dbl>, hdcf_percent <dbl>, xgf <dbl>,
#> #   xga <dbl>, xgf_percent <dbl>, gf <dbl>, ga <dbl>, gf_percent <dbl>,
#> #   toi_sec <dbl>
#> 
#> $tev
#> # A tibble: 8 × 25
#>   team    period toi      cf    ca cf_percent    ff    fa ff_percent    sf    sa
#>   <chr>   <chr>  <chr> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
#> 1 Bruins  1      13:14    18    11      0.621    12     7      0.632    10     7
#> 2 Bruins  2      17:08    17    18      0.486    10    13      0.435     8     6
#> 3 Bruins  3      16:00    18    25      0.419    15    21      0.417    10    17
#> 4 Bruins  Final  46:22    53    54      0.495    37    41      0.474    28    30
#> 5 Panthe… 1      13:14    11    18      0.379     7    12      0.368     7    10
#> 6 Panthe… 2      17:08    18    17      0.514    13    10      0.565     6     8
#> 7 Panthe… 3      16:00    25    18      0.581    21    15      0.583    17    10
#> 8 Panthe… Final  46:22    54    53      0.505    41    37      0.526    30    28
#> # ℹ 14 more variables: sf_percent <dbl>, scf <dbl>, sca <dbl>,
#> #   scf_percent <dbl>, hdcf <dbl>, hdca <dbl>, hdcf_percent <dbl>, xgf <dbl>,
#> #   xga <dbl>, xgf_percent <dbl>, gf <dbl>, ga <dbl>, gf_percent <dbl>,
#> #   toi_sec <dbl>
#> 
#> $t5v5
#> # A tibble: 8 × 25
#>   team    period toi      cf    ca cf_percent    ff    fa ff_percent    sf    sa
#>   <chr>   <chr>  <chr> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
#> 1 Bruins  1      13:14    18    11      0.621    12     7      0.632    10     7
#> 2 Bruins  2      17:08    17    18      0.486    10    13      0.435     8     6
#> 3 Bruins  3      12:17    16    13      0.552    13    11      0.542     9     9
#> 4 Bruins  Final  42:39    51    42      0.548    35    31      0.530    27    22
#> 5 Panthe… 1      13:14    11    18      0.379     7    12      0.368     7    10
#> 6 Panthe… 2      17:08    18    17      0.514    13    10      0.565     6     8
#> 7 Panthe… 3      12:17    13    16      0.448    11    13      0.458     9     9
#> 8 Panthe… Final  42:39    42    51      0.452    31    35      0.470    22    27
#> # ℹ 14 more variables: sf_percent <dbl>, scf <dbl>, sca <dbl>,
#> #   scf_percent <dbl>, hdcf <dbl>, hdca <dbl>, hdcf_percent <dbl>, xgf <dbl>,
#> #   xga <dbl>, xgf_percent <dbl>, gf <dbl>, ga <dbl>, gf_percent <dbl>,
#> #   toi_sec <dbl>
#> 
#> $tsva
#> # A tibble: 8 × 25
#>   team    period toi      cf    ca cf_percent    ff    fa ff_percent    sf    sa
#>   <chr>   <chr>  <chr> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
#> 1 Bruins  1      13:14  18.8  10.5      0.642 12.4   6.76      0.646 10.3   6.76
#> 2 Bruins  2      17:08  17.0  17.8      0.488 10.0  13.0       0.435  7.96  5.98
#> 3 Bruins  3      12:17  17.1  12.0      0.587 13.7  10.4       0.568  9.49  8.5 
#> 4 Bruins  Final  42:39  53.0  40.4      0.568 36.0  30.2       0.544 27.7  21.2 
#> 5 Panthe… 1      13:14  10.5  18.8      0.358  6.76 12.4       0.354  6.76 10.3 
#> 6 Panthe… 2      17:08  17.8  17.0      0.511 13.0  10.0       0.565  5.98  7.96
#> 7 Panthe… 3      12:17  12.0  17.1      0.413 10.4  13.7       0.432  8.5   9.49
#> 8 Panthe… Final  42:39  40.4  53.0      0.432 30.2  36.0       0.456 21.2  27.7 
#> # ℹ 14 more variables: sf_percent <dbl>, scf <dbl>, sca <dbl>,
#> #   scf_percent <dbl>, hdcf <dbl>, hdca <dbl>, hdcf_percent <dbl>, xgf <dbl>,
#> #   xga <dbl>, xgf_percent <dbl>, gf <dbl>, ga <dbl>, gf_percent <dbl>,
#> #   toi_sec <dbl>
#> 
#> $tpp
#> # A tibble: 8 × 25
#>   team    period toi      cf    ca cf_percent    ff    fa ff_percent    sf    sa
#>   <chr>   <chr>  <chr> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
#> 1 Bruins  1      3:08      5     0      1         2     0      1         1     0
#> 2 Bruins  2      0:52      1     1      0.5       1     1      0.5       1     1
#> 3 Bruins  3      2:00      5     1      0.833     5     1      0.833     3     1
#> 4 Bruins  Final  6:00     11     2      0.846     8     2      0.8       5     2
#> 5 Panthe… 1      3:16      3     1      0.75      3     1      0.75      3     1
#> 6 Panthe… 2      2:00      5     0      1         3     0      1         3     0
#> 7 Panthe… 3      0:53      7     0      1         5     0      1         2     0
#> 8 Panthe… Final  6:09     15     1      0.938    11     1      0.917     8     1
#> # ℹ 14 more variables: sf_percent <dbl>, scf <dbl>, sca <dbl>,
#> #   scf_percent <dbl>, hdcf <dbl>, hdca <dbl>, hdcf_percent <dbl>, xgf <dbl>,
#> #   xga <dbl>, xgf_percent <dbl>, gf <dbl>, ga <dbl>, gf_percent <dbl>,
#> #   toi_sec <dbl>
#> 
#> $tpk
#> # A tibble: 8 × 25
#>   team    period toi      cf    ca cf_percent    ff    fa ff_percent    sf    sa
#>   <chr>   <chr>  <chr> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
#> 1 Bruins  1      3:16      1     3     0.25       1     3     0.25       1     3
#> 2 Bruins  2      2:00      0     5     0          0     3     0          0     3
#> 3 Bruins  3      0:53      0     7     0          0     5     0          0     2
#> 4 Bruins  Final  6:09      1    15     0.0625     1    11     0.0833     1     8
#> 5 Panthe… 1      3:08      0     5     0          0     2     0          0     1
#> 6 Panthe… 2      0:52      1     1     0.5        1     1     0.5        1     1
#> 7 Panthe… 3      2:00      1     5     0.167      1     5     0.167      1     3
#> 8 Panthe… Final  6:00      2    11     0.154      2     8     0.2        2     5
#> # ℹ 14 more variables: sf_percent <dbl>, scf <dbl>, sca <dbl>,
#> #   scf_percent <dbl>, hdcf <dbl>, hdca <dbl>, hdcf_percent <dbl>, xgf <dbl>,
#> #   xga <dbl>, xgf_percent <dbl>, gf <dbl>, ga <dbl>, gf_percent <dbl>,
#> #   toi_sec <dbl>
```

The `game_id` parameter is of the NHL Game ID style and season a 8 digit
number (i.e. 20222023 for the 2022-2023 season).

Alternatively rearrange the output by calling:

``` r
nst_report(20222023, 20041)
#> # A tibble: 2 × 44
#>   team    h_a   cf_all ff_all sf_all scf_all hdcf_all xgf_all gf_all cf_ev ff_ev
#>   <chr>   <chr>  <dbl>  <dbl>  <dbl>   <dbl>    <dbl>   <dbl>  <dbl> <dbl> <dbl>
#> 1 Bruins  home      66     47     34      31       18    3.88      5    53    37
#> 2 Panthe… away      78     56     41      43       12    3.67      3    54    41
#> # ℹ 33 more variables: sf_ev <dbl>, scf_ev <dbl>, hdcf_ev <dbl>, xgf_ev <dbl>,
#> #   gf_ev <dbl>, cf_5v5 <dbl>, ff_5v5 <dbl>, sf_5v5 <dbl>, scf_5v5 <dbl>,
#> #   hdcf_5v5 <dbl>, xgf_5v5 <dbl>, gf_5v5 <dbl>, cf_sva <dbl>, ff_sva <dbl>,
#> #   sf_sva <dbl>, scf_sva <dbl>, hdcf_sva <dbl>, xgf_sva <dbl>, gf_sva <dbl>,
#> #   cf_pp <dbl>, ff_pp <dbl>, sf_pp <dbl>, scf_pp <dbl>, hdcf_pp <dbl>,
#> #   xgf_pp <dbl>, gf_pp <dbl>, cf_pk <dbl>, ff_pk <dbl>, sf_pk <dbl>,
#> #   scf_pk <dbl>, hdcf_pk <dbl>, xgf_pk <dbl>, gf_pk <dbl>
```

Note that the abbreviations are all explained on the Natural Stat Trick
website at <https://www.naturalstattrick.com/glossary.php?teams>.
