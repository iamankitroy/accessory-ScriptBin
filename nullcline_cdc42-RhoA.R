k = seq(0, 2, 0.05)
m = seq(1, 5, 1)
C = seq(0.01, 4, 0.01)

storeC = c()
storeK = c()
storeM = c()
storeR = c()

yfun = function(C) ((3.4*ki^mi - C*ki^mi)/C)^(1/mi)

for (ki in k) {
    for (mi in m) {
        storeC = c(storeC, C)
        storeK = c(storeK, rep(c(ki), each = length(C)))
        storeM = c(storeM, rep(c(mi), each = length(C)))
        storeR = c(storeR, c(yfun(C)))
    }
}

df = data.frame("C" = storeC, "kc" = storeK, "m" = storeM, "R" = storeR)

df$m = as.factor(df$m)

ggplot(subset(df, subset = kc == "1.25"), aes(C, R)) + geom_line(aes(colour = m), size = 0.5) + scale_y_continuous(limits = c(0,4))

# Ankit Roy
# 9th September 2021