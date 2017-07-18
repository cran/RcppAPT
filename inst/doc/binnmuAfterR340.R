## ---- eval=FALSE---------------------------------------------------------
#  > library(RcppAPT)
#  > library(data.table)
#  > rd <- reverseDepends("r-base-core")         # 514 x 2
#  > rd <- rd[!grepl("r-(doc|base)", rd[,1]), ]  # 506 x 2
#  > rd <- rd[grepl("^r-", rd[,1]), ]            # 480 x 2
#  > rd <- rd[order(rd[,2]), ]
#  > setDT(rd)

## ---- eval=FALSE---------------------------------------------------------
#  > rd
#                  package          version
#    1:   r-cran-phylobase 3.2.4.20160406-1
#    2:       r-cran-zelig          3.0.2-1
#    3:        r-cran-urca          3.4.0-1
#    4:     r-cran-tseries 3.3.3.20170413-1
#    5:     r-cran-tkrplot 3.3.0.20160615-1
#   ---
#  476:      r-cran-bitops          3.0.1-6
#  477: r-cran-cairodevice          3.4.0-1
#  478:        r-cran-boot          3.4.0-1
#  479:     r-cran-acepack          3.4.0-1
#  480:       r-cran-abind          3.3.1-1
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > rd[ version=="3.0.0~20130330-1", version := "3.0.0.20130330-1"]
#  > rd[ version=="3.2.4-revised-1", version := "3.2.4.1-1"]
#  > rd[version!="", oldVersion := version  <=  package_version("3.3.3-1")]
#  > rd[ is.na(oldVersion), oldVersion := FALSE]
#  > rd
#                  package          version oldVersion
#    1:   r-cran-phylobase 3.2.4.20160406-1       TRUE
#    2:       r-cran-zelig          3.0.2-1       TRUE
#    3:        r-cran-urca          3.4.0-1      FALSE
#    4:     r-cran-tseries 3.3.3.20170413-1      FALSE
#    5:     r-cran-tkrplot 3.3.0.20160615-1       TRUE
#   ---
#  476:      r-cran-bitops          3.0.1-6       TRUE
#  477: r-cran-cairodevice          3.4.0-1      FALSE
#  478:        r-cran-boot          3.4.0-1      FALSE
#  479:     r-cran-acepack          3.4.0-1      FALSE
#  480:       r-cran-abind          3.3.1-1       TRUE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > rd[ version=="", skip:=TRUE ]
#  > rd[ is.na(skip), skip:=FALSE]
#  > rd
#                  package          version oldVersion  skip
#    1:   r-cran-phylobase 3.2.4.20160406-1       TRUE FALSE
#    2:       r-cran-zelig          3.0.2-1       TRUE FALSE
#    3:        r-cran-urca          3.4.0-1      FALSE FALSE
#    4:     r-cran-tseries 3.3.3.20170413-1      FALSE FALSE
#    5:     r-cran-tkrplot 3.3.0.20160615-1       TRUE FALSE
#   ---
#  476:      r-cran-bitops          3.0.1-6       TRUE FALSE
#  477: r-cran-cairodevice          3.4.0-1      FALSE FALSE
#  478:        r-cran-boot          3.4.0-1      FALSE FALSE
#  479:     r-cran-acepack          3.4.0-1      FALSE FALSE
#  480:       r-cran-abind          3.3.1-1       TRUE FALSE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > regexp <- paste(paste0("^", rd[skip==FALSE, package], "$"), collapse="|")
#  > dep <- getDepends(regexp)
#  > setDT(dep)
#  > dep
#                    srcpkg              deppkg cmpop          version
#     1:  r-bioc-hypergraph         r-base-core     2 3.3.1.20161024-1
#     2:  r-bioc-hypergraph             r-api-3     0           (null)
#     3:  r-bioc-hypergraph        r-bioc-graph     0           (null)
#     4:  r-bioc-hypergraph r-bioc-biocgenerics     0           (null)
#     5:  r-bioc-hypergraph        r-cran-runit     0           (null)
#    ---
#  3690: r-cran-viridislite             r-api-3     0           (null)
#  3691:      r-cran-xtable         r-base-core     2          3.2.5-1
#  3692:      r-cran-xtable             r-api-3     0           (null)
#  3693:   r-cran-pkgkitten         r-base-core     2          3.3.2-1
#  3694:   r-cran-pkgkitten             r-api-3     0           (null)
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > comp <- dep[deppkg=="libc6"]   # about 241
#  > comp[, isCompiled:=TRUE]
#  > comp
#                   srcpkg deppkg cmpop version isCompiled
#    1:  r-bioc-makecdfenv  libc6     2     2.4       TRUE
#    2:       r-cran-bio3d  libc6     2    2.14       TRUE
#    3:   r-bioc-rsamtools  libc6     2    2.15       TRUE
#    4:     r-cran-foreign  libc6     2    2.14       TRUE
#    5:    r-bioc-multtest  libc6     2    2.14       TRUE
#   ---
#  237:     r-cran-nleqslv  libc6     2     2.4       TRUE
#  238: r-other-amsmercury  libc6     2    2.14       TRUE
#  239:         r-cran-gnm  libc6     2     2.4       TRUE
#  240:         r-cran-gsl  libc6     2     2.4       TRUE
#  241:         r-cran-gss  libc6     2     2.4       TRUE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > setkey(comp, srcpkg)
#  > setkey(rd, package)
#  > all <- rd[comp[, c(1,5)]]   # inner join (by default on columns with keys)
#  > all[order(version),]
#                        package version oldVersion  skip isCompiled
#    1:            r-cran-bitops 3.0.1-6       TRUE FALSE       TRUE
#    2:               r-cran-mnp 3.0.2-1       TRUE FALSE       TRUE
#    3: r-other-mott-happy.hbrem 3.0.2-1       TRUE FALSE       TRUE
#    4:             r-cran-amore 3.1.0-1       TRUE FALSE       TRUE
#    5:              r-cran-deal 3.1.0-1       TRUE FALSE       TRUE
#   ---
#  237:           r-cran-statmod 3.4.1-1      FALSE FALSE       TRUE
#  238:               r-cran-ape 3.4.1-2      FALSE FALSE       TRUE
#  239:           r-cran-nleqslv 3.4.1-2      FALSE FALSE       TRUE
#  240:            r-cran-rmysql 3.4.1-2      FALSE FALSE       TRUE
#  241:                r-mathlib 3.4.1-2      FALSE FALSE       TRUE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > all[oldVersion==TRUE,][order(version),]    # 167
#                        package version oldVersion  skip isCompiled
#    1:            r-cran-bitops 3.0.1-6       TRUE FALSE       TRUE
#    2:               r-cran-mnp 3.0.2-1       TRUE FALSE       TRUE
#    3: r-other-mott-happy.hbrem 3.0.2-1       TRUE FALSE       TRUE
#    4:             r-cran-amore 3.1.0-1       TRUE FALSE       TRUE
#    5:              r-cran-deal 3.1.0-1       TRUE FALSE       TRUE
#   ---
#  163:           r-cran-rcppgsl 3.3.3-1       TRUE FALSE       TRUE
#  164:             r-cran-rodbc 3.3.3-1       TRUE FALSE       TRUE
#  165:         r-cran-snowballc 3.3.3-1       TRUE FALSE       TRUE
#  166:                r-cran-v8 3.3.3-1       TRUE FALSE       TRUE
#  167:               r-cran-zoo 3.3.3-1       TRUE FALSE       TRUE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > all[, cran:=grepl("^r-cran", package) ]
#  > all[, bioc:=grepl("^r-bioc", package) ]
#  > all[bioc==TRUE & oldVersion==TRUE,]                # 17 BioC
#                    package          version oldVersion  skip isCompiled  cran bioc
#   1:           r-bioc-affy 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#   2:         r-bioc-affyio 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#   3:        r-bioc-biobase 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#   4:     r-bioc-biovizbase          3.3.2-1       TRUE FALSE       TRUE FALSE TRUE
#   5:         r-bioc-deseq2          3.3.2-1       TRUE FALSE       TRUE FALSE TRUE
#   6:        r-bioc-dnacopy 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#   7:          r-bioc-edger          3.3.0-2       TRUE FALSE       TRUE FALSE TRUE
#   8:     r-bioc-genefilter          3.3.2-1       TRUE FALSE       TRUE FALSE TRUE
#   9:          r-bioc-graph 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#  10:     r-bioc-hilbertvis 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#  11:          r-bioc-limma          3.3.2-1       TRUE FALSE       TRUE FALSE TRUE
#  12:     r-bioc-makecdfenv 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#  13:       r-bioc-multtest 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#  14: r-bioc-preprocesscore 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#  15:           r-bioc-rbgl          3.3.2-1       TRUE FALSE       TRUE FALSE TRUE
#  16:    r-bioc-rtracklayer          3.3.2-1       TRUE FALSE       TRUE FALSE TRUE
#  17:       r-bioc-snpstats 3.3.1.20161024-1       TRUE FALSE       TRUE FALSE TRUE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > all[bioc!=TRUE & cran!=TRUE & oldVersion==TRUE,]   # 3 other
#                      package version oldVersion  skip isCompiled  cran  bioc
#  1:       r-other-amsmercury 3.3.2-1       TRUE FALSE       TRUE FALSE FALSE
#  2:          r-other-iwrlars 3.3.2-1       TRUE FALSE       TRUE FALSE FALSE
#  3: r-other-mott-happy.hbrem 3.0.2-1       TRUE FALSE       TRUE FALSE FALSE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > cand <- all[ cran==TRUE & oldVersion==TRUE, ]   # 147
#  > cand
#               package version oldVersion  skip isCompiled cran  bioc
#    1:     r-cran-ade4 3.3.2-1       TRUE FALSE       TRUE TRUE FALSE
#    2: r-cran-adegenet 3.3.1-1       TRUE FALSE       TRUE TRUE FALSE
#    3: r-cran-adephylo 3.3.2-1       TRUE FALSE       TRUE TRUE FALSE
#    4:   r-cran-amelia 3.2.3-1       TRUE FALSE       TRUE TRUE FALSE
#    5:    r-cran-amore 3.1.0-1       TRUE FALSE       TRUE TRUE FALSE
#   ---
#  143:    r-cran-vegan 3.3.2-1       TRUE FALSE       TRUE TRUE FALSE
#  144:     r-cran-vgam 3.3.2-1       TRUE FALSE       TRUE TRUE FALSE
#  145:     r-cran-xml2 3.3.2-1       TRUE FALSE       TRUE TRUE FALSE
#  146:     r-cran-yaml 3.3.2-1       TRUE FALSE       TRUE TRUE FALSE
#  147:      r-cran-zoo 3.3.3-1       TRUE FALSE       TRUE TRUE FALSE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > db <- tools::CRAN_package_db()   # CRAN pkge info: N rows x 65 cols
#  > setDT(db)
#  > db[, package:=paste0("r-cran-", tolower(Package))]
#  > setkey(db, package)              # key on package field
#  > foo <- db[ cand ]                # inner join
#  > foo[, .(package, Package, Version, NeedsCompilation, oldVersion, skip)]
#               package  Package Version NeedsCompilation oldVersion  skip
#    1:     r-cran-ade4     ade4   1.7-6              yes       TRUE FALSE
#    2: r-cran-adegenet adegenet   2.0.1              yes       TRUE FALSE
#    3: r-cran-adephylo adephylo  1.1-10              yes       TRUE FALSE
#    4:   r-cran-amelia   Amelia   1.7.4              yes       TRUE FALSE
#    5:    r-cran-amore    AMORE  0.2-15              yes       TRUE FALSE
#   ---
#  143:    r-cran-vegan    vegan   2.4-3              yes       TRUE FALSE
#  144:     r-cran-vgam     VGAM   1.0-3              yes       TRUE FALSE
#  145:     r-cran-xml2     xml2   1.1.1              yes       TRUE FALSE
#  146:     r-cran-yaml     yaml  2.1.14              yes       TRUE FALSE
#  147:      r-cran-zoo      zoo   1.8-0              yes       TRUE FALSE
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > saveRDS(foo[, .(package, Package, Version, NeedsCompilation, oldVersion, skip)], file="debpackages.rds")

## ---- eval=FALSE---------------------------------------------------------
#  deb <- readRDS("debpackages.rds")
#  for (i in 1:nrow(deb)) {
#      deb[i, "dotCorFortran"] <- if (is.na(deb[i, "Package"])) NA
#                                 else system(paste0("egrep -r -q \"\\.(C|Fortran)\\(\" ", deb[i, "Package"], "/R/*"))==0
#  }
#  saveRDS(deb, "debpackagesout.rds")

## ---- eval=FALSE---------------------------------------------------------
#  > deb <- readRDS("debpackagesout.rds")
#  > setDT(deb)
#  > deb[ is.na(deb[, dotCorFortran]) | deb[, dotCorFortran]==TRUE, 1:3]   ## 72
#                      package           Package  Version
#   1:              r-cran-ade4              ade4    1.7-6
#   2:          r-cran-adegenet          adegenet    2.0.1
#   3:          r-cran-adephylo          adephylo   1.1-10
#   4:            r-cran-amelia            Amelia    1.7.4
#   5:            r-cran-bayesm            bayesm    3.1-0
#   6:            r-cran-bitops            bitops    1.0-6
#   7:     r-cran-blockmodeling     blockmodeling    0.1.9
#   8:           r-cran-boolnet           BoolNet    2.1.3
#   9:             r-cran-brglm             brglm    0.6.1
#  10:             r-cran-caret             caret   6.0-76
#  11:           r-cran-catools           caTools   1.17.1
#  12:            r-cran-cmprsk            cmprsk    2.2-7
#  13:              r-cran-coin              coin    1.2-0
#  14:          r-cran-contfrac          contfrac   1.1-11
#  15:        r-cran-data.table        data.table   1.10.4
#  16:              r-cran-deal              deal   1.2-37
#  17:            r-cran-deldir            deldir   0.1-14
#  18:           r-cran-desolve           deSolve     1.20
#  19:       r-cran-dosefinding       DoseFinding   0.9-15
#  20:               r-cran-eco               eco    3.1-7
#  21:               r-cran-erm               eRm   0.15-7
#  22:               r-cran-etm               etm    0.6-2
#  23:               r-cran-evd               evd    2.3-2
#  24:              r-cran-expm              expm  0.999-2
#  25:            r-cran-fields            fields      9.0
#  26:               r-cran-gam               gam   1.14-4
#  27:           r-cran-genabel           GenABEL    1.8-0
#  28:            r-cran-glmnet            glmnet   2.0-10
#  29:           r-cran-goftest           goftest    1.1-1
#  30:               r-cran-gsl               gsl 1.9-10.3
#  31:       r-cran-haplo.stats       haplo.stats    1.7.7
#  32:              r-cran-hdf5                NA       NA
#  33:            r-cran-hexbin            hexbin   1.27.1
#  34:            r-cran-igraph            igraph    1.0.1
#  35:               r-cran-lhs               lhs     0.14
#  36:         r-cran-logspline         logspline    2.1.9
#  37:           r-cran-mapproj           mapproj    1.2-5
#  38:              r-cran-maps              maps    3.2.0
#  39:          r-cran-maptools          maptools    0.9-2
#  40:              r-cran-mcmc              mcmc    0.9-5
#  41:          r-cran-mcmcpack          MCMCpack    1.4-0
#  42:      r-cran-medadherence                NA       NA
#  43:          r-cran-mixtools          mixtools    1.1.0
#  44:           r-cran-mlbench           mlbench    2.1-1
#  45:               r-cran-mnp               MNP    3.0-2
#  46:               r-cran-msm               msm    1.6.4
#  47:             r-cran-ncdf4             ncdf4     1.16
#  48:              r-cran-nnls              nnls      1.4
#  49:          r-cran-pbivnorm          pbivnorm    0.6.0
#  50:          r-cran-phangorn          phangorn    2.2.0
#  51:         r-cran-phylobase         phylobase    0.8.4
#  52:           r-cran-polycub           polyCub    0.6.0
#  53:         r-cran-princurve         princurve   1.1-12
#  54:              r-cran-pscl              pscl    1.4.9
#  55:               r-cran-qtl               qtl   1.41-6
#  56:      r-cran-randomfields      RandomFields   3.1.50
#  57: r-cran-randomfieldsutils RandomFieldsUtils   0.3.25
#  58:      r-cran-randomforest      randomForest   4.6-12
#  59:      r-cran-raschsampler      RaschSampler    0.8-8
#  60:             r-cran-rcurl             RCurl 1.95-4.8
#  61:         r-cran-rniftilib                NA       NA
#  62:                r-cran-sp                sp    1.2-5
#  63:              r-cran-spam              spam    2.1-1
#  64:          r-cran-spatstat          spatstat   1.51-0
#  65:               r-cran-spc               spc    0.5.3
#  66:             r-cran-spdep             spdep   0.6-13
#  67:      r-cran-surveillance      surveillance   1.14.0
#  68:               r-cran-tgp               tgp   2.4-14
#  69:        r-cran-tikzdevice        tikzDevice   0.10-1
#  70:         r-cran-treescape                NA       NA
#  71:             r-cran-vegan             vegan    2.4-3
#  72:              r-cran-vgam              VGAM    1.0-3
#                       package           Package  Version
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > nmu <- deb[ is.na(deb[, dotCorFortran]) | deb[, dotCorFortran]==TRUE, 1]
#  > nmu <- rbind(nmu,  all[bioc!=TRUE & cran!=TRUE & oldVersion==TRUE, 1]) # 'other'
#  > nmu <- rbind(nmu,  all[bioc==TRUE & oldVersion==TRUE, 1])              # BioC
#  >
#  > options("width"=80)
#  > nmu[[1]]
#   [1] "r-cran-ade4"              "r-cran-adegenet"
#   [3] "r-cran-adephylo"          "r-cran-amelia"
#   [5] "r-cran-bayesm"            "r-cran-bitops"
#   [7] "r-cran-blockmodeling"     "r-cran-boolnet"
#   [9] "r-cran-brglm"             "r-cran-caret"
#  [11] "r-cran-catools"           "r-cran-cmprsk"
#  [13] "r-cran-coin"              "r-cran-contfrac"
#  [15] "r-cran-data.table"        "r-cran-deal"
#  [17] "r-cran-deldir"            "r-cran-desolve"
#  [19] "r-cran-dosefinding"       "r-cran-eco"
#  [21] "r-cran-erm"               "r-cran-etm"
#  [23] "r-cran-evd"               "r-cran-expm"
#  [25] "r-cran-fields"            "r-cran-gam"
#  [27] "r-cran-genabel"           "r-cran-glmnet"
#  [29] "r-cran-goftest"           "r-cran-gsl"
#  [31] "r-cran-haplo.stats"       "r-cran-hdf5"
#  [33] "r-cran-hexbin"            "r-cran-igraph"
#  [35] "r-cran-lhs"               "r-cran-logspline"
#  [37] "r-cran-mapproj"           "r-cran-maps"
#  [39] "r-cran-maptools"          "r-cran-mcmc"
#  [41] "r-cran-mcmcpack"          "r-cran-medadherence"
#  [43] "r-cran-mixtools"          "r-cran-mlbench"
#  [45] "r-cran-mnp"               "r-cran-msm"
#  [47] "r-cran-ncdf4"             "r-cran-nnls"
#  [49] "r-cran-pbivnorm"          "r-cran-phangorn"
#  [51] "r-cran-phylobase"         "r-cran-polycub"
#  [53] "r-cran-princurve"         "r-cran-pscl"
#  [55] "r-cran-qtl"               "r-cran-randomfields"
#  [57] "r-cran-randomfieldsutils" "r-cran-randomforest"
#  [59] "r-cran-raschsampler"      "r-cran-rcurl"
#  [61] "r-cran-rniftilib"         "r-cran-sp"
#  [63] "r-cran-spam"              "r-cran-spatstat"
#  [65] "r-cran-spc"               "r-cran-spdep"
#  [67] "r-cran-surveillance"      "r-cran-tgp"
#  [69] "r-cran-tikzdevice"        "r-cran-treescape"
#  [71] "r-cran-vegan"             "r-cran-vgam"
#  [73] "r-other-amsmercury"       "r-other-iwrlars"
#  [75] "r-other-mott-happy.hbrem" "r-bioc-affy"
#  [77] "r-bioc-affyio"            "r-bioc-biobase"
#  [79] "r-bioc-biovizbase"        "r-bioc-deseq2"
#  [81] "r-bioc-dnacopy"           "r-bioc-edger"
#  [83] "r-bioc-genefilter"        "r-bioc-graph"
#  [85] "r-bioc-hilbertvis"        "r-bioc-limma"
#  [87] "r-bioc-makecdfenv"        "r-bioc-multtest"
#  [89] "r-bioc-preprocesscore"    "r-bioc-rbgl"
#  [91] "r-bioc-rtracklayer"       "r-bioc-snpstats"
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > regexp <- paste(paste0("^", nmu[[1]], "$"), collapse="|")
#  > res <- getPackages(regexp)
#  > res
#  > res
#                      Package         Version
#  1         r-bioc-makecdfenv        1.50.0-1
#  2           r-bioc-multtest        2.30.0-1
#  3              r-bioc-edger   3.14.0+dfsg-1
#  4            r-cran-boolnet         2.1.3-1
#  5         r-cran-tikzdevice        0.10-1-1
#  6          r-cran-logspline         2.1.9-1
#  7            r-cran-genabel      1.8-0-1+b1
#  8                r-cran-lhs          0.14-1
#  9              r-bioc-limma   3.30.8+dfsg-1
#  10              r-cran-coin         1.1-3-1
#  11          r-other-iwrlars         0.9-5-2
#  12               r-cran-mnp         2.6-4-1
#  13               r-cran-msm         1.6.4-1
#  14            r-cran-fields          8.10-1
#  15           r-cran-desolve          1.14-1
#  16          r-cran-adephylo        1.1-10-2
#  17       r-cran-dosefinding        0.9-15-1
#  18            r-cran-deldir        0.1-12-1
#  19         r-cran-rniftilib    0.0-35.r79-2
#  20        r-cran-data.table        1.10.0-1
#  21               r-cran-qtl        1.40-8-1
#  22    r-bioc-preprocesscore        1.36.0-1
#  23          r-cran-contfrac        1.1-10-1
#  24            r-cran-glmnet         2.0-5-1
#  25            r-cran-bitops         1.0-6-1
#  26                r-cran-sp       1:1.2-4-1
#  27               r-cran-spc       1:0.5.3-1
#  28          r-bioc-snpstats   1.24.0+dfsg-1
#  29               r-cran-tgp        2.4-14-2
#  30             r-cran-brglm         0.5-9-1
#  31            r-cran-cmprsk         2.2-7-2
#  32              r-bioc-affy        1.52.0-1
#  33             r-cran-ncdf4       1.15-1+b2
#  34         r-cran-treescape       1.10.18-6
#  35              r-bioc-rbgl  1.50.0+dfsg1-1
#  36       r-bioc-rtracklayer        1.34.1-1
#  37            r-cran-hexbin        1.27.1-1
#  38         r-cran-princurve        1.1-12-1
#  39           r-cran-mapproj         1.2-4-1
#  40     r-cran-blockmodeling         0.1.8-1
#  41              r-cran-hdf5     1.6.10-4+b1
#  42              r-cran-pscl         1.4.9-1
#  43              r-cran-ade4         1.7-5-1
#  44              r-cran-vgam         1.0-3-1
#  45          r-cran-adegenet         2.0.1-1
#  46          r-cran-mixtools         1.0.4-1
#  47         r-cran-phylobase         0.8.2-1
#  48            r-cran-amelia         1.7.4-1
#  49              r-cran-spam         1.4-0-1
#  50      r-cran-medadherence          1.03-2
#  51           r-bioc-biobase        2.34.0-1
#  52      r-cran-surveillance        1.13.0-1
#  53 r-cran-randomfieldsutils        0.3.15-1
#  54              r-cran-deal      1:1.2-37-2
#  55        r-bioc-hilbertvis        1.32.0-1
#  56             r-cran-rcurl      1.95-4.8-2
#  57 r-other-mott-happy.hbrem           2.4-1
#  58          r-cran-mcmcpack         1.3-8-1
#  59          r-cran-spatstat        1.48-0-1
#  60             r-cran-vegan         2.4-2-1
#  61       r-cran-haplo.stats         1.7.7-1
#  62            r-cran-bayesm         3.0-2-2
#  63              r-cran-expm       0.999-0-1
#  64           r-bioc-dnacopy        1.48.0-1
#  65          r-cran-phangorn         2.1.1-1
#  66          r-cran-maptools 1:0.8-41+dfsg-1
#  67           r-cran-mlbench         2.1-1-1
#  68            r-bioc-affyio        1.44.0-1
#  69             r-bioc-graph        1.52.0-1
#  70           r-cran-polycub         0.5-2-1
#  71            r-bioc-deseq2        1.14.1-1
#  72          r-cran-pbivnorm         0.6.0-1
#  73             r-cran-caret  6.0-73+dfsg1-1
#  74        r-bioc-biovizbase        1.22.0-2
#  75              r-cran-nnls           1.4-1
#  76           r-cran-goftest         1.0-3-1
#  77            r-cran-igraph         1.0.1-1
#  78              r-cran-maps         3.1.1-1
#  79               r-cran-eco         3.1-7-1
#  80           r-cran-catools     1.17.1-1+b1
#  81      r-cran-randomfields        3.1.36-1
#  82               r-cran-erm        0.15-7-1
#  83               r-cran-etm         0.6-2-3
#  84      r-cran-randomforest        4.6-12-1
#  85               r-cran-evd         2.3-2-1
#  86      r-cran-raschsampler         0.8-8-1
#  87        r-bioc-genefilter        1.56.0-1
#  88              r-cran-mcmc         0.9-4-2
#  89             r-cran-spdep         0.6-9-1
#  90               r-cran-gam          1.14-1
#  91       r-other-amsmercury         1.3.0-2
#  92               r-cran-gsl      1.9-10.3-1
#  >

## ---- eval=FALSE---------------------------------------------------------
#  > for (i in 1:nrow(res)) cat("nmu", paste(res[i,], collapse="_"), ". ANY . -m 'Rebuild against R 3.4.*, see #861333'\n")
#  nmu r-bioc-makecdfenv_1.50.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-multtest_2.30.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-edger_3.14.0+dfsg-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-boolnet_2.1.3-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-tikzdevice_0.10-1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-logspline_2.1.9-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-genabel_1.8-0-1+b1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-lhs_0.14-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-limma_3.30.8+dfsg-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-coin_1.1-3-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-other-iwrlars_0.9-5-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-mnp_2.6-4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-msm_1.6.4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-fields_8.10-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-desolve_1.14-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-adephylo_1.1-10-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-dosefinding_0.9-15-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-deldir_0.1-12-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-rniftilib_0.0-35.r79-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-data.table_1.10.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-qtl_1.40-8-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-preprocesscore_1.36.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-contfrac_1.1-10-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-glmnet_2.0-5-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-bitops_1.0-6-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-sp_1:1.2-4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-spc_1:0.5.3-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-snpstats_1.24.0+dfsg-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-tgp_2.4-14-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-brglm_0.5-9-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-cmprsk_2.2-7-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-affy_1.52.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-ncdf4_1.15-1+b2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-treescape_1.10.18-6 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-rbgl_1.50.0+dfsg1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-rtracklayer_1.34.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-hexbin_1.27.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-princurve_1.1-12-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-mapproj_1.2-4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-blockmodeling_0.1.8-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-hdf5_1.6.10-4+b1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-pscl_1.4.9-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-ade4_1.7-5-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-vgam_1.0-3-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-adegenet_2.0.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-mixtools_1.0.4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-phylobase_0.8.2-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-amelia_1.7.4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-spam_1.4-0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-medadherence_1.03-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-biobase_2.34.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-surveillance_1.13.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-randomfieldsutils_0.3.15-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-deal_1:1.2-37-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-hilbertvis_1.32.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-rcurl_1.95-4.8-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-other-mott-happy.hbrem_2.4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-mcmcpack_1.3-8-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-spatstat_1.48-0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-vegan_2.4-2-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-haplo.stats_1.7.7-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-bayesm_3.0-2-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-expm_0.999-0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-dnacopy_1.48.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-phangorn_2.1.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-maptools_1:0.8-41+dfsg-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-mlbench_2.1-1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-affyio_1.44.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-graph_1.52.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-polycub_0.5-2-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-deseq2_1.14.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-pbivnorm_0.6.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-caret_6.0-73+dfsg1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-biovizbase_1.22.0-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-nnls_1.4-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-goftest_1.0-3-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-igraph_1.0.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-maps_3.1.1-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-eco_3.1-7-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-catools_1.17.1-1+b1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-randomfields_3.1.36-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-erm_0.15-7-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-etm_0.6-2-3 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-randomforest_4.6-12-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-evd_2.3-2-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-raschsampler_0.8-8-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-bioc-genefilter_1.56.0-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-mcmc_0.9-4-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-spdep_0.6-9-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-gam_1.14-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-other-amsmercury_1.3.0-2 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  nmu r-cran-gsl_1.9-10.3-1 . ANY . -m 'Rebuild against R 3.4.*, see #861333'
#  >
