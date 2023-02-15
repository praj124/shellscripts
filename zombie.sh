Identify the zombie processes

top -b1 -n1 | grep Z


2) Find the parent of zombie processes

ps -A -ostat,ppid | grep -e '[zZ]'| awk '{ print $2 }' | uniq | xargs ps -p


Note the parent process ID (ppid) is 27229

3) Send SIGCHLD signal to the parent process. This signal tells the parent process to execute the wait() system call and clean up its zombie children

kill -s SIGCHLD ppid

4) Identify if the zombie processes have been killed

top -b1 -n1 | grep Z

If there are still zombie processes then the parent process isn't programmed properly and is ignoring SIGCHLD signals.

You'll have to kill or close the zombies' parent process. (Step 5)

When the process that created the zombies ends, init inherits the zombie processes and becomes their new parent. (init is the first process started on Linux at boot and is assigned PID 1). init periodically executes the wait() system call to clean up its zombie children, so init will make short work of the zombies.

5) Kill the parent process

kill -9 ppid
