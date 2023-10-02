library(Rmpi)

## Données
n <- 100000
set.seed(666)

dat <- data.frame(rnorm(n, 1234, 10),
                  rchisq(n, 20),
                  rt(n, 42),
                  rbeta(n, 0.1, 2))

## On doit avoir autant de worker que la longueur de la liste.
mpi.spawn.Rslaves(nslaves = length(dat))

## Extension de `mpi.scatter` permettant de travailler facilement avec
## une liste.
mpi.scatter.Robj2slave(dat)

mpi.bcast.cmd({
    ## Réduit-centre le vecteur
    dat <- scale(dat)

    ## Retourne le résultat au manager.
    mpi.gather.Robj(dat)
})

## Récupère les vecteurs
dat <- as.data.frame(mpi.gather.Robj(dat))
colnames(dat) <- c(paste0("Orig", seq_len(ncol(dat) / 2)),
                   paste0("Scaled", seq_len(ncol(dat) / 2)))

print(head(dat))
cat("--------\nMoyennes\n--------\n")
print(colMeans(dat))
cat("--------\nÉcarts-type\n--------\n")
print(sapply(dat, sd))

mpi.close.Rslaves()
mpi.quit()
