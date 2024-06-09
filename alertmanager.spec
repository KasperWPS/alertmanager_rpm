Name:           prometheus-alertmanager
Version:        %{version_}
Release:        %{release_}%{?dist}
Summary:        Alertmanager v.%{version}

License:        GPLv2.1
#URL:
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  golang
Requires:       golang-github-prometheus >= 2.32.1-9

Provides:       %{name} = %{version}

%description
Prometheus alertmanager.

%global debug_package %{nil}

%prep
%autosetup


%build
make build

%install
install -Dpm 0755 alertmanager %{buildroot}%{_bindir}/%{name}
install -Dpm 0755 amtool %{buildroot}%{_bindir}/amtool
install -Dpm 0644 dep/%{name}.service %{buildroot}%{_unitdir}/%{name}.service
install -Dpm 0644 dep/%{name} %{buildroot}%{_sysconfdir}/default/%{name}
install -Dpm 0640 dep/alertmanager.yml %{buildroot}%{_sysconfdir}/prometheus/alertmanager.yml
mkdir -p %{buildroot}%{_sharedstatedir}/prometheus/alertmanager

%files
%{_bindir}/%{name}
%{_bindir}/amtool
%{_unitdir}/%{name}.service
%config(noreplace) %{_sysconfdir}/default/%{name}
%config(noreplace) %{_sysconfdir}/prometheus/alertmanager.yml
%dir %{_sharedstatedir}/prometheus/alertmanager

%changelog
* Sat Jun 08 2024 Ivan Ivanov <kasper_wps@mail.ru>
- First release
