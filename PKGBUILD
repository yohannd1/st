# Maintainer:

pkgname=st-yd
_pkgname=st
pkgver=0.8.5.r1406.51e7359
pkgrel=1
epoch=1
pkgdesc="A fork of Luke Smith's fork of simple (suckless) terminal."
arch=('i686' 'x86_64')
license=('MIT')
options=('zipman')
depends=('libxft')
makedepends=('ncurses' 'libxext' 'git')
optdepends=('dmenu: feed urls to dmenu')
source=()
sha1sums=()

provides=("${_pkgname}")
conflicts=("${_pkgname}")

pkgver() {
	printf "%s.r%s.%s" "$(awk '/^VERSION =/ {print $3}' ../config.mk)" \
		"$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
  :
}

build() {
  cd ..
	make X11INC=/usr/include/X11 X11LIB=/usr/lib/X11
}

package() {
  cd ..
  make PREFIX=/usr DESTDIR="${pkgdir}" install
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
  install -Dm644 README.md "${pkgdir}/usr/share/doc/${pkgname}/README.md"
  install -Dm644 Xdefaults "${pkgdir}/usr/share/doc/${pkgname}/Xdefaults.example"
}
