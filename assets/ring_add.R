library(Rmpi)

## Crée les workers.
nworkers <- 5
mpi.spawn.Rslaves(nslaves = nworkers)

## Exécute la commande suivante sur chaque worker.
mpi.bcast.cmd({
    x <- integer(1L)

    task <- function(nworkers) {
        rank <- mpi.comm.rank()

        ## Reçoit la variable `x` du worker précédent ou du manager si rank = 1.
        mpi.recv(x, 1, rank - 1, 0)

        ## Ajoute 1.
        x <- x + 1

        ## Envoie `x` au prochain worker ou au manager si rank = nworkers.
        dst <- ifelse(rank < nworkers, rank + 1, 0)
        mpi.send(x, 1, dst, 0)
    }
})

## Valeur initiale de `x`.
x <- 0L

## Envoie `x` au premier worker.
mpi.send(x, 1, 1, 0)

## Exécute la tâche.
mpi.bcast.cmd(cmd = task, nworkers)

x <- mpi.recv(x, 1, nworkers, 0)

cat("x =", x, "\n")

mpi.close.Rslaves()
mpi.quit()
