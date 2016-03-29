Name:           phonetic
Version:        VERSION
Release:        RELEASE
Summary:        transforms a stream of characters into a stream of words (mostly NATO words)

Group:          Administrative
License:        GNU/GPL3
URL:            git@github.com:desertedscorpion/whitevenus.git
Source:         %{name}-%{version}.tar.gz
Prefix:         %{_prefix}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       coreutils sed
%define debug_package %{nil}


%description
This program takes an input stream of characters and outputs a stream of words.
Most of these words come from the NATO alphabet.
(https://en.wikipedia.org/wiki/NATO_phonetic_alphabet).
Other words like Comma, Question, etc., I came up with myself.
Words associated with letters are written either ALL UPPER CASE or all lower case to indicate the case of the associated letter.
Other words are written in mixed case.

%prep
%setup -q


%build


%install
rm -rf ${RPM_BUILD_ROOT}
mkdir --parents ${RPM_BUILD_ROOT}/usr/local/bin
cp phonetic.sh ${RPM_BUILD_ROOT}/usr/local/bin/phonetic


%clean
rm -rf $RPM_BUILD_ROOT


%files
%attr(0555,root,root) /usr/local/bin/phonetic
