# compile_yambo_everywhere
Collection of configuration scripts, tricks and other stuff on how to compile and set up a running yambo on different machines.

## File format

For each new cluster/machine, we provide a new folder. Inside this folder, each file can be either a:
- configure-x-y.sh, where x and y are repsectively: yambo version (5.1, 5.2 and so on) and machine (Leonardo, Piz-Daint and so on); they should contain both *module loading/swtiching* and *configure execution with options provided*, and also some line explaining why such options are used (why intel_2020 and not intel_2021 and so on...). It HAS to be specified if the code is compiled for GPU or not (you may also provide both cases); Eventually, list also the executable that you have successfully compiled.
- tricks.txt, in which we collect tricks to perform compilation (for example "in machine x the version Y of the compiler has a bug...)
