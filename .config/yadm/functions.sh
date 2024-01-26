get_os() {

	os=$( grep ID= /etc/os-release | head -n1 | cut -f2 -d= )	

	echo "$os"

}

prop() {
	grep "^$2=" "$1" | cut -f2 -d=
}

install_package() {

	case $( get_os ) in
		arch)
			while [ $# -gt 0 ]; do
				_arch_install_package "$1"
				shift
			done
			;;

		gentoo)
			if ! _gentoo_package_installed eselect-repository; then
				_sudo emerge --ignore-default-opts -n eselect-repository
			fi
			while [ $# -gt 0 ]; do
				_gentoo_install_package "$1"
				shift
			done
			;;

		*)
			echo "UNSUPPORTED IMPLEMENT NAO!!!"
			exit 1
			;;

	esac

}

_gentoo_package_installed() {
	qlist -I "$1" >/dev/null 2>&1
	return $?
}

_gentoo_repo_active() {
	eselect repository list -i | grep " $1 " >/dev/null 2>&1
	return $?
}

_gentoo_install_package() {

	software_name=$1
	package_name=$( prop gentoo.packages "$software_name.pkg" )

	echo "Installing $software_name..."

	if [ -z "$package_name" ]; then
		echo "Package unknown, please install it manually now."
		echo "Press enter to continue..."
		read -r
		return
	fi

	if _gentoo_package_installed "$package_name"; then
		echo "Already installed!"
		return
	fi

	repo=$(prop gentoo.packages "$software_name.repo" )

	if [ -n "$repo" -a "$( _gentoo_repo_active "$repo" ; echo $? )" -gt 0 ]; then
		echo "Enabling $repo repo...."
		_sudo eselect repository enable "$repo"
		_sudo emerge --ignore-default-opts --sync
		return
	fi

	unmask=$( prop gentoo.packages "$software_name.unmask" )
	if _contains "keywords" "$unmask"; then
		if [ ! -d /etc/portage/package.accept_keywords ]; then
			mkdir --parents /etc/portage/package.accept_keywords
		fi

		echo "$package_name ~$( _cpu )" | _sudo tee -a /etc/portage/package.accept_keywords/yadm
	fi

	_sudo emerge -n --ignore-default-opts $package_name
}


_arch_install_package() {

	software_name=$1
	package_name=$( prop arch.packages "$software_name.pkg" )

	echo "Installing $software_name..."

	if [ -z "$package_name" ]; then
		echo "Package unknown, please install it manually now."
		echo "Press enter to continue..."
		read -r
		return
	fi

	if _arch_package_installed "$package_name"; then
		echo "Already installed!"
		return
	fi

	aur=$(prop arch.packages "$software_name.aur" )

	if [ -z "$aur" ]; then
		_sudo pacman -Sy --needed --noconfirm "$package_name"
		return
	fi

	echo "Detected AUR package."
	_arch_install_aur_package "$package_name"

}

_arch_install_aur_package() {

	if _arch_package_installed "paru"; then
		paru -Sy --needed --noconfirm "$1"
		return
	elif _arch_package_installed "yay"; then
		yay -Sy --needed --noconfirm "$1"
		return
	fi

	echo "No paru or yay, trying manual install..."

	_sudo pacman -Sy --needed --noconfirm base-devel curl

	mkdir --parents /tmp/aur
	cd /tmp/aur || echo "Cannot install aur packages!" && exit

	curl -sLO "https://aur.archlinux.org/cgit/aur.git/snapshot/${package_name}.tar.gz"
	tar xaf "${package_name}.tar.gz"
	cd "${package_name}" || echo "Failed to extract package!" && exit

	makepkg -si --needed --noconfirm

}

_arch_package_installed() {
	pacman -Qi "$1" >/dev/null 2>&1
	return $?
}

_can_run() {
	type "$1" >/dev/null 2>&1
	return $?
}

_sudo() {
	if _can_run "doas"; then
		doas "$@"
	elif _can_run "sudo"; then
		sudo "$@"
	else
		su -c "$@"
	fi
}

_contains() {
	keyword=$1
	shift
	echo "$*" | grep "$keyword" >/dev/null 2>&1
	return $?
}

_cpu() {
	cpu=$( uname -m )
	case $cpu in
		x86_64)
			echo "amd64"
			;;
		*)
			echo $cpu
			;;
	esac
}
