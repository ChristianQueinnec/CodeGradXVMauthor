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
the `codegradxlib` Node module and can be operated from a browser.

CodeGradX may also be operated from command line using the
`codegradxagent` Node module. By default, `codegradxlib` is configured
to use the real constellation of CodeGradX servers howwver authors may
use a virtual machine, named [VMauthor
](http://paracamplus.com/CodeGradX/VM/CodeGradX-VMauthor-latest.img.bz2),
to write and check their exercises with their own computing resources.
The new `codegradxvmauthor` Node module reconfigures `codegradxlib` to
use this virtual machine.

To sum up: this module is the configuration of CodeGradXagent for VMauthor.

## Installation

```javascript
npm install codegradxvmauthor
```

When VMauthor runs, you should memorize the IP number attributed to
that VM, this is required to access the VM. You may alternatively
enrich your `/etc/hosts` file and add a line defining
`vmauthor.codegradx.org` to be that IP number. Something like

```
192.168.133.201  vmauthor vmauthor.codegradx.org
```

## Use

You may access the VMauthor virtual machine when browsing
`http://vmauthor/`, interactively submit new exercises and test them
as a student. However you may also prefer to script these interactions
in which case, your script requires some credentials to access VMauthor.

### Getting credentials

Credentials are JSON files that may be fetched from VMauthor. These
files define a user name and a cookie (valid a few hours):

```shell
wget -O fw4ex-author.json   http://vmauthor/fw4exjson/0
wget -O fw4ex-student1.json http://vmauthor/fw4exjson/1
```

### 








