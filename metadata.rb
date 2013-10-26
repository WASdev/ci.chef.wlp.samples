name             'wlp-samples'
maintainer       'IBM'
maintainer_email 'YOUR_EMAIL'
license          'Apache 2.0'
description      'Installs WebSphere Application Server Liberty Profile Samples'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "wlp"
depends "mongodb"
depends "apache2"
depends "application_wlp"
