# Script to simulate different nullclines on Cdc42-RhoA activity phase plane
# Data from Jilkine et. al. 2007

k = seq(0, 2, 0.05)         # half-activation concentration of Cdc42
m = seq(1, 5, 1)            # Hill-coefficient
C = seq(0.01, 4, 0.01)      # Cdc42 concentration

storeC = c()                # all Cdc42 concentrations
storeK = c()                # all different k
storeM = c()                # all different m
storeR = c()                # predicted concentration of RhoA

# Function to calculate the concentration of RhoA
calcR = function(C) ((3.4*ki^mi - C*ki^mi)/C)^(1/mi)

# Predict values for various k and m combinations
for (ki in k) {
    for (mi in m) {
        storeC = c(storeC, C)
        storeK = c(storeK, rep(c(ki), each = length(C)))
        storeM = c(storeM, rep(c(mi), each = length(C)))
        storeR = c(storeR, c(calcR(C)))
    }
}

df = data.frame("C" = storeC, "kc" = storeK, "m" = storeM, "R" = storeR)

df$m = as.factor(df$m)

# Plot
ggplot(subset(df, subset = kc == "1.25"), aes(C, R)) +
    geom_line(aes(colour = m), size = 0.5) +
    scale_y_continuous(limits = c(0,4))

# Ankit Roy
# 9th September 2021
