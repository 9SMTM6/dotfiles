## Key-management with fido2

Works also with yubikey bio and yubikey security key
https://developers.yubico.com/SSH/Securing_git_with_SSH_and_FIDO2.html
https://www.yubico.com/blog/github-now-supports-ssh-security-keys/

Needs openssh >= 8.2, libfido2, git >= 2.34

explanations: 

* `sk` stands for security key, the token
* `resident`-key aka Discoverable Credentials, key gets stored on security key (can be recovered as shown later)
* `verify-required` private key requires user verification, eg a pin or biometric
* `no-touch-required` dont require presence verification
* `-O user`, `-O application=ssh:` distinction of keys (evades override), application must begin with `ssh:` for some reason (`man ssh-keygen`)
* `-C` documentation

```sh
# Generate push key for bio:
ssh-keygen -t ed25519-sk -O resident -O verify-required -O user=smaier-bio -O application=ssh:remote-git -C "yubikeyBio-remote-git-1-$(date +'%Y-%m-%d')"
# Generate push key for Security Key:
ssh-keygen -t ed25519-sk -O resident -O verify-required -O user=smaier-sk1 -O application=ssh:remote-git -C "yubikeySK1-remote-git-1-$(date +'%Y-%m-%d')"

# Generate commit key for bio:
ssh-keygen -t ed25519-sk -O resident -O no-touch-required -O user=smaier-bio -O application=ssh:auth -C "yubikeyBio-auth-1-$(date +'%Y-%m-%d')"
# Generate commit key for Security Key:
ssh-keygen -t ed25519-sk -O resident -O no-touch-required -O user=smaier-sk1 -O application=ssh:auth -C "yubikeySK1-auth-1-$(date +'%Y-%m-%d')"

# Add resident key(s?) to device temporarily (needs active ssh-agent: `ssh-agent -s`):
ssh-add -K
# Add resident key(s?) to device permanently:
ssh-keygen  -K
```