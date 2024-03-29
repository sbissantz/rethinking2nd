#
# Prior predictive simulation
#

# Note: I found it most useful to do PPS in R. But you can also do it in Stan.
#

#
# Simulating the posterior line (mu)
#

# Standardized

# In a nutshell
#
N <- 1e2
a <- rnorm(N, 0, 0.2)
b <- rnorm(N, 0, 0.5)
plot(NULL, xlim=c(-3,3), ylim=c(-3, 3),
     xlab="Weight (std)", ylab="Height (std)")
abline(h=c(-2,2), lty=2)
for(i in seq(50)) abline(a[i], b[i], col=scales::alpha("steelblue", .8))

# Documented version
#

# Define the number of elements to simulate
N <- 1e2

# alpha prior
mu <- 0
sigma <- 0.2
a <- rnorm(N, mu, sigma)
# Note: Argument to justify the PD: MAXENT!

# beta prior
mu <- 0
sigma <- 0.5
b <- rnorm(N, mu, sigma)
# Note: Argument to justify the PD: MAXENT!

# value ranges
# A Std.normal distribution implies that approximately 99% of the values
# lies within +/-3*Sigma. See: pnorm(3)

# Visualize
#
plot(NULL, xlim=c(-3,3), ylim=c(-3, 3),
     xlab="Weight (std)", ylab="Height (std)")
# High probability region
abline(h=c(-2,2), lty=2)
# 50 prior lines for mu
for(i in seq(50)) abline(a[i], b[i], col=scales::alpha("steelblue", .8))
# curve() version
#for(i in 1:N) {
  #curve(a[i] + b[i]*x, from=min(d$weight), to=max(d$weight),
        #add=TRUE, col=scales::alpha("black", .2))
#}


# Unstandardized

# Note: For unstandardized variables we need some data
set.seed(345)
N <- 1e2
weight <- rnorm(N, 60, 10) ; height <- rnorm(weight, 170, 20)
d <- data.frame(weight, height)
# Note: these data are ridiculous!

# In a nutshell
#
N <- 1e2
a <- rnorm(N, 160, 40)
b <- rnorm(N, 0.001, 0.1)
x <- d$weight ; y <- d$height

# Robert Wadlow (272 cm)
# Chandra Bahadur Dangi (54,6 cm)
# Jon Brower Minnoch (635 kg)
# Lucía Zárate (2,1 kg)
plot(NULL, xlim=range(0, 700), ylim=c(40, 300),
     xlab="Weight (kg)", ylab="Height (cm)")
largest <- 272  ; heaviest  <- 635
smallest <- 54 ; lightest <- 2
abline(h=c(54,272), v=c(2, 635), lty=2)
for(i in seq(50)) abline(a[i], b[i], col=scales::alpha("steelblue", .8))

# Documented version
#

# Define the number of elements to simulate
N <- 1e2

# alpha prior
a <- rnorm(N, 160, 40)
# Note: Argument to justify the PD: MAXENT!

# beta prior
b <- rnorm(N, 0.001, 0.1)
# Note: Argument to justify the PD: MAXENT!

# Value ranges
# Robert Wadlow (272 cm)
# Chandra Bahadur Dangi (54,6 cm)
# Jon Brower Minnoch (635 kg)
# Lucía Zárate (2,1 kg)
x <- d$weight ; y <- d$height
largest <- 272  ; heaviest  <- 635
smallest <- 54 ; lightest <- 2

plot(NULL, xlim=range(0, 700), ylim=c(40, 300),
     xlab="Weight (kg)", ylab="Height (cm)")
# High probability region
abline(h=c(smallest,largest), v=c(heaviest, lightest), lty=2)
for(i in seq(50)) abline(a[i], b[i], col=scales::alpha("steelblue", .8))
# curve() version
#for(i in 1:N) {
  #curve(a[i] + b[i]*x, from=lightest, to=heaviest,
        #add=TRUE, col=scales::alpha("black", .2))
#}

# TODO: Integrate sigma and plot raw data against prior predictions?
# See: Search Stan manual for PPS

#
# Simulating posterior predictions
# (aka. Prior Predictive Checks)
#

# standardized

# In a nutshell
#
N <- 1e2
a <- rnorm(N, 0, 0.2)
b <- rnorm(N, 0, 0.5)
x <- seq(-3,3, length.out=N)
mu <- a + b * x
sigma <- rexp(N, 1)
y_tilde <- rnorm(N, mu, sigma)
plot(x, y_tilde, ylim=c(-3, 3), xlab="x", ylab="y_tilde", pch=20,
     col="steelblue")
abline(a=0, b=1, lty=2)

#
# Documented version
#

# Define the number of elements to simulate
N <- 1e2

# Note: Joint prior model

# alpha prior
a <- rnorm(N, 0, 0.2)

# beta prior
b <- rnorm(N, 0, 0.5)

# Value range
x <- seq(-3,3, length.out=N)

# mu as a linear function of alpha and beta
mu <- a + b * x

# sigma prior
sigma <- rexp(N, 1)

# Simulate values for y
y_tilde <- rnorm(N, mu, sigma)
# Note: This is how the robot sees the data before you feed it the ones!

# Visualize
plot(x, y_tilde, ylim=c(-3, 3), xlab="x", ylab="y_tilde", pch=20,
     col=scales::alpha("steelblue", .8))
# Bisecting line
abline(a=0, b=1, lty=2)

# TODO

#
# Posterior predictions vs. data | x
#
#############################
# Note: should be real data!
X <- rnorm(N)
y <- rnorm(X)
d <- list(X=X, y=y)
#############################
plot(d$X, y_tilde, ylim=c(-4, 4), xlab="x", ylab="y_tilde", pch=20,
     col=scales::alpha("steelblue", .8))
points(d$X, d$y, pch=20,
     col=scales::alpha("black", .8))
for(i in 1:N)  lines(x = c(d$X[i], d$X[i]), y=c(y_tilde[i], d$y[i]),
                     col=scales::alpha("black", .5))
legend("topright", fill = c("steelblue", "black") , legend=c("Prior", "Data"))

#
# Posterior predictions vs. data
#
plot(d$y, y_tilde, ylim=c(-4, 4), xlab="y", ylab="y_tilde", pch=20,
     col=scales::alpha("steelblue", .8))
abline(a=0, b=1, lty=2)
