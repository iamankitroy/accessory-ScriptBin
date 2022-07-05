# This script is used to calculate quantum yield and fluorescence lifetimes of fluorophores
# Different fluorescence rate (gamma) and non-radiative rates (k_nr) are sampled
# The relationship between quantum yield and fluorescence lifetimes with varying gamma and k_nr is plotted

library(dplyr)
library(ggplot2)

decay_rates = seq(1e7, 2e9, 1e7)		# decay rates
all_gammas = c()						# fluorescence decay rates
all_knrs = c()							# non-radiative decay rates

# sample decay rates
for (gamma in decay_rates) {
	for (knr in decay_rates) {
		all_gammas = append(all_gammas, gamma)		# store fluorescence decay rate
		all_knrs = append(all_knrs, knr)			# store non-radiative decay rate
	}
}

# data frame to store fluorescence data
fluorescence_df = data.frame("gamma" = all_gammas,
							 "knr" = all_knrs)

# calculate quantum yield
fluorescence_df = fluorescence_df %>%
	mutate(Q = gamma/(gamma + knr))

# calculate fluorescence lifetime in ns
fluorescence_df = fluorescence_df %>%
	mutate(tau = (1/(gamma + knr))*1e9)

# log10 transform
fluorescence_df$gamma_log10 = log10(fluorescence_df$gamma)
fluorescence_df$knr_log10 = log10(fluorescence_df$knr)

# Quantum yield as a function of gamma and k_nr
q_plot = ggplot(fluorescence_df, aes(gamma, knr, fill = Q)) +
	geom_tile() +
	scale_fill_gradientn(colours = c("blue", "white", "red"),
						 limits = c(0, 1),
						 guide = guide_colorbar(frame.colour = "black")) +
	scale_x_continuous(expand = c(0,0)) +
	scale_y_continuous(expand = c(0,0)) +
	xlab(bquote("\u0393")) +
	ylab(bquote("k"[nr])) +
	theme_bw() +
	theme(aspect.ratio = 1)

# Fluorescence lifetime as a function of gamma and k_nr
tau_plot = ggplot(fluorescence_df, aes(gamma, knr, fill = tau)) +
	geom_tile() +
	scale_fill_gradientn(colours = c("blue", "white", "red"),
						 limits = c(0, 50),
						 guide = guide_colorbar(frame.colour = "black")) +
	scale_x_continuous(expand = c(0,0), limits = c(0.5e7, 1.25e8)) +
	scale_y_continuous(expand = c(0,0), limits = c(0.5e7, 1.25e8)) +
	xlab(bquote("\u0393")) +
	ylab(bquote("k"[nr])) +
	labs(fill = bquote("\u03c4 (ns)")) +
	theme_bw() +
	theme(aspect.ratio = 1)

# Distribution of quantum yield and fluorescence lifetime as a function of gamma and k_nr
q_tau_combined = ggplot(fluorescence_df, aes(Q, tau, color = gamma_log10, fill = knr_log10)) +
	geom_point(shape = 21) +
	scale_color_gradientn(colors = c("black", "gold"),
						  guide = guide_colorbar(frame.colour = "black")) +
	scale_fill_gradientn(colours = c("white", "blue"),
						 guide = guide_colorbar(frame.colour = "black")) +
	scale_x_continuous(expand = c(0.01,0)) +
	scale_y_continuous(expand = c(0.01,0)) +
	labs(color = bquote("log"[10]*"\u0393"),
		 fill = bquote("log"[10]*"k"[nr])) +
	ylab(bquote("\u03c4 (ns)")) +
	theme_dark() +
	theme(aspect.ratio = 1)

# Ankit Roy
# 5th July, 2022