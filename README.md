# CodeGradXvmauthor

CodeGradX is a grading infrastructure
- where students submit programs to solve exercises and these programs
  are mechanically graded,
- where authors deploy exercises and propose them to students,
- where teachers may follow the progress of a cohort of students.

The [CodeGradX](http://paracamplus.com/spip/spip.php?rubrique2)
infrastructure is operated via REST protocols. To ease its use,
CodeGradXlib is a Javascript Library that provides a programmatic API
to operate the CodeGradX infrastructure. This library is contained in
the `codegradxlib` Node module.

CodeGradX may also be operated from command line using the
`codegradxagent` Node module. By default, `codegradxlib` is configured
to use the real constellation of CodeGradX servers howwver authors may
use a virtual machine, named [VMauthor
](http://paracamplus.com/CodeGradX/VM/CodeGradX-VMauthor-latest.img.bz2),
to write and check their exercises. The new `codegradxvmauthor` Node
module reconfigures `codegradxlib` to use this virtual machine.

To sum up: this module is the configuration of CodeGradXagent for VMauthor.

## Installation

```javascript
npm install codegradxvmauthor
```

When VMauthor runs, memorize the IP number of that VM, this is required
to access the VM. You may also enrich your `/etc/hosts` file and add
a line defining `vmauthor` to be that IP number. Something like

```
192.168.133.201  vmauthor
```



## Use






