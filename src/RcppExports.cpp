// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// getPackages
Rcpp::DataFrame getPackages(const std::string regexp = ".");
RcppExport SEXP RcppAPT_getPackages(SEXP regexpSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const std::string >::type regexp(regexpSEXP);
    __result = Rcpp::wrap(getPackages(regexp));
    return __result;
END_RCPP
}
// hasPackages
Rcpp::LogicalVector hasPackages(Rcpp::CharacterVector pkg);
RcppExport SEXP RcppAPT_hasPackages(SEXP pkgSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< Rcpp::CharacterVector >::type pkg(pkgSEXP);
    __result = Rcpp::wrap(hasPackages(pkg));
    return __result;
END_RCPP
}