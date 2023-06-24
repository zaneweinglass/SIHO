# function to compute the y outputs for the density of an exponential function with a given rate parameter
exp_func <- function(x_input, lambda_rate) {
    dexp(x = x_input, rate = lambda_rate)
}
