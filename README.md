### bitsort - an optimized sort algorithm

Michael (misc) Myer, 2012-2019, misc.myer@zoho.com


Somehow I got the feeling, 
it's (finally) time to publish some research,
I did more than 10 years before. (The files on my harddisk's and backups date back to 2012;
but I'm sure, I did these experiments at the time when I lived in Nuremberg)
So I'm claiming prior rights; and I'm releasing this approach, as well as the accompanying sources, 
under the terms of the GPL - as far as applicable.

It's a sort algorithm, which might be a specialized implementation of radix sort.

However, benchmarks show, the implementation is for most datasets twice as fast as other algorithms;
e.g. glibc qsort. 
Furthermore, my implementation (I'm calling "bitsort") has a constant memory usage of N;
is very good suitable for parallelization, and might scale very well from small to big data.

I somehow guess, this approach has been overseen, cause usually you look at the complexity first.
However, complexity is a heuristic aspect - the overall performance is determined by more factors.
Memory usage, e.g. But, and here the heuristic assumption of a turing machine won't help
in general - the most important factors are instruction cycles of the instructions used;
memory and caches usage also in terms of access patterns, and prediction hits.


#### So, whats going on here..:

Firstly, the algorithm utilizes the "test" instruction.
This instruction tests a selectable bit of an address in memory.
Surprisingly, this instruction is cheap in terms of cpu cycles on most architectures.
(Compare, e.g., aigner) 
For most cpu's the instruction needs 1/3 cpu cycles, INDEPENDENT of the operator (register or memory)
Other sorting implementations either do a cmp, or copy the memory data into a register - 
both cases are slower than test.


Secondly, the algorithm utilizes a divide and conquer approach. 
(I believe, it's a radix sort implementation - but have to look this up)
The data is divided, depending on the first bit;
then, the divided data again is going to be divided by the second bit, andsoon..
So, it's possible to either sort after the first pass in parallel, doubling the count
of processes after each pass, until the number of cpus/threads is consumed and processing.

Splitting data subsets and merging them afterwards is possible as well.


Then, the cpu's and memory's caches are used in a machine optimized way.
Splitting and iterating sequentially has the big advantage of utilizing the pipelines and caches
in a very machine optimized way.


... I'm going to explain further, for now I'm preparing and uploading the sources to github.
