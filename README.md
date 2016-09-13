# Opan uploader

## SYNOPSIS

### run opan uploader
```
#manual
docker run -v /var/lib/opan:/opan -p8081:8081 avastsoftware/opan_uploader
#or as a service (only systemd linux)
cp opan_uploader.service /etc/systemd/system/
systemctl start opan_uploader.service
```

### send a distribution to opan uploader
```
curl -XPOST --data-binary @Perl-Module-1.0.0.tar.gz upload.opan.server:8081/add?dist=Perl-Module-1.0.0.tar.gz
#or
wget --post-file Perl-Module-1.0.0.tar.gz upload.opan.server:8081/add?&dist=Perl-Module-1.0.0.tar.gz
#or
curl -F "dist=@Perl-Module-1.0.0.tar.gz" upload.opan.server:8081/add

#for using in CI job - exit if service return no_success http code, but eat error message from server 
curl -sSf -F "dist=@Perl-Module-1.0.0.tar.gz" upload.opan.server:8081/add
#or (this is maybe ogly, but print error message)
if [[$(curl -s -o /dev/stderr -w "%{http_code}" -F dist=@Perl-Module-1.0.0.tar.gz 'upload.opan.server:8081/add') != 200]]; then exit 1; fi
```

### use carton/cpanm with opan API
```
cpanm --mirror http://localhost:8081/combined/ --mirror-only --installdeps .
```

```
PERL_CARTON_MIRROR=http://localhost:8081/combined carton install
```

## DESCRIPTION
[App::opan](https://metacpan.org/pod/distribution/App-opan) is an awesome tool for managing
internal repository of Perl distributions.
[avastsoftware/opan](https://hub.docker.com/r/avastsoftware/opan) is docker
container with *opan API* on entrypoint (and with opan tool inside).
However, *opan API* 'only' has the same interface as CPAN, i.e. it only enables
distributions to be fetched from it. This project
[avastsoftware/opan_uploader](https://hub.docker.com/r/avastsoftware/opan_uploader/)
complements it. It enables to upload Perl distributions to the opan
repository (e.g. a company-wide internal repository).

*opan uploader* do [opan add](https://metacpan.org/pod/distribution/App-opan/script/opan#add) and [opan pull](https://metacpan.org/pod/distribution/App-opan/script/opan#pull)

## CAVEATS AND LIMITATIONS
There is no authorization / authentication implemented: everyone who can access
the server is able to push a distribution into the repository. A possible
solution is to put *Basic access authentication* on proxy http server before
*opan uploader*.

## SEE ALSO
*opan uploader* is a replacement for manual call of opan command on a opan
server with *avastsoftware/opan* service.
```
scp Perl-Module-1.0.0.tar.gz opan.server:/tmp
ssh opan.server docker run -v/var/lib/opan:/opan avastsoftware/opan add /tmp/Perl-Module-1.0.0.tar.gz
ssh opan.server docker run -v/var/lib/opan:/opan avastsoftware/opan pull
```
