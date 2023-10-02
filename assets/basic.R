library(Rmpi)

## Crée les workers.
nworkers <- 5
mpi.spawn.Rslaves(nslaves = nworkers)

## Demande à chaque worker de retourner son rang.
mpi.remote.exec(mpi.comm.rank())

## On termine!
mpi.close.Rslaves()
mpi.quit()
