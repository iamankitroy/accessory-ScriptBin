library(ggplot2)
library(dplyr)

r0 = 0.4
taus = c(0.1, 1, 5, 10, 25, 50) * 1e-9	# fluorophore lifetimes in s
eta = 0.954 * 1e-3						# viscosity of water in Pa
v_bar = 0.708							# partial specific volume of proteins in ml•g-1
R = 8.31								# gas constant in J•K-1•mol-1
temp = 273.15 + 22						# 22°C in K

v_bar = v_bar * 1e-6					# convert to m3•g-1

mws = 10^seq(3, 6, 1e-2)				# range of molecular weights

all_taus = c()							# stores all lifetimes
all_mws = c()							# stores all molecular weights

# sample different lifetimes and molecular weights
for (tau in taus) {
	for (mw in mws) {
		all_taus = append(all_taus, tau)
		all_mws = append(all_mws, mw)
	}
}

# data frame to store anisotropy data
anisotropy_df = data.frame("tau" = all_taus,
						   "mw" = all_mws)

# function to calculate rotational correlation time
calc_rotTime = function(m) (eta * m * v_bar)/(R * temp)
# function to calculate anisotropy
calc_anisotropy = function(t, theta) r0/(1 + t/theta)

# calculate rotational correlation time
anisotropy_df = anisotropy_df %>%
	mutate(theta_c = calc_rotTime(mw))

# calculate anisotropy
anisotropy_df = anisotropy_df %>%
	mutate(r = calc_anisotropy(tau, theta_c))

# convert lifetimes to ns
anisotropy_df$tau_ns = anisotropy_df$tau * 1e9

# create label positions such that labels are placed at positions closest to coordinate (0, 0.4)
anisotropy_df = anisotropy_df %>%
	group_by(tau) %>%
	mutate(dist = (0-mw/1e6)^2 + (1-r/0.4)^2) %>%
	mutate(label_pos = ifelse(dist == min(dist), as.character(tau_ns), NA)) %>%
	ungroup()

# convert lifetime to factors
anisotropy_df$tau_ns = factor(anisotropy_df$tau_ns)

# plot relationship between molecular weight of proteins, lifetime of attached fluorophores and their anisotropy
anisotropy_plot = ggplot(anisotropy_df, aes(mw, r, colour = tau_ns)) +
	geom_line(size = 1.15) +
	geom_label(aes(label = label_pos,
				   x = mw - max(mws)*0.0185,
				   y = r + r0*0.0185),
			   size = 4,
			   label.size = NA,
			   show.legend = FALSE) +
	labs(color = bquote("\u03c4 (ns)")) +
	xlab("Molecular Weight (kDa)") +
	ylab("r") +
	ggtitle(bquote("Fluorescence anisotropy (r) as a function of molecular weight and fluorescence lifetime (\u03c4) at 22°C")) +
	theme_bw() +
	theme(aspect.ratio = 0.85,
		  plot.title = element_text(hjust = 0.5))

ggsave("anisotropy_r-mw_v_tau.png",
	   plot = anisotropy_plot,
	   dpi = 300)


# Ankit Roy
# 21st July, 2022