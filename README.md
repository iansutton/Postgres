puppet-profile-dev
==================

1. Clone git repo
2. Write new profile code in the 'manifests' folder (see guide below)
3. Add test code to the 'tests' folder (see guide below)
4. If you wish to test hiera lookups add an appropriate yaml file to the 'files' folder and ensure that it is referenced in files/hiera.yaml

Now to test it.

5. Run bundel install to install the ruby gems requied to build and test your profile code.
6. Run the build script - this will package up your profile in to an installable module.
7. bring up the vagrant vm.

```shell
bundel install
./build.sh
vagrant up
```

The vagrant vm's provisioning script will install your profile and its dependencies, run syntax and style (lint) tests against your profile code andd will then call your test code to install the module.

If all is well the vagrant vm will come up with out error - you can then ssh in to the vagrant vm to check that your profile code has produced the intended results.

NB if you need to run the test again you will need to exit and destroy the vagrant vm, rerun build.sh and then re-run vagrant up.


Manifest layout:

```
# Class profiles::<CLASS_NAME>
# This class will <DESCRIPTION OF CLASS FUNCTION>.
#
# Parameters: #Paramiters accepted by the class
# ['<PARAMITER_NAME>'] - <PARAMITER_TYPE>
#
# Requires: #Modules required by the class
# - <AUTHOR>/<MODULE>
#
# Sample Usage:
# class { 'profiles::<CLASS_NAME>': }
#
# Hiera:
# <EXAMPLE OF ANY REQUIRED HIERA STRUCTURE>
#
class profiles::<CLASS_NAME> (
  $<PARAMITER_NAME(S)>
  ) {
    # <AUTHOR>/<MODULE>
    class { '::<MODULE>':
    <MODULE_CONFIGURATION> => $<PARAMITER_NAME>,
  }
}
```

Test layout:

```
include ::profiles::<CLASS_NAME>
```
