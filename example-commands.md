## Key-management with fido2

Works also with yubikey bio and yubikey security key
https://developers.yubico.com/SSH/Securing_git_with_SSH_and_FIDO2.html
https://www.yubico.com/blog/github-now-supports-ssh-security-keys/

Needs openssh >= 8.3, libfido2, git >= 2.34

explanations: 

* `sk` stands for security key, the token
* `resident`-key aka Discoverable Credentials, key gets stored on security key (can be recovered as shown later)
* `verify-required` private key requires user verification, eg a pin or biometric
* `no-touch-required` dont require presence verification
* `-O user`, `-O application=ssh:` distinction of keys (evades override), application must begin with `ssh:` for some reason (`man ssh-keygen`)
* `-C` documentation

```sh
# Generate access key for bio:
ssh-keygen -t ed25519-sk -O resident -O verify-required -O user=smaier-bio -O application=ssh:access -C "yubikeyBio-access-1-$(date +'%Y-%m-%d')" -f ~/.ssh/id_ed25519_sk_bio
# Generate access key for Security Key:
ssh-keygen -t ed25519-sk -O resident -O verify-required -O user=smaier-sk1 -O application=ssh:access -C "yubikeySK1-access-1-$(date +'%Y-%m-%d')" -f ~/.ssh/id_ed25519_sk_sk1

# Generate sign key for bio:
ssh-keygen -t ed25519-sk -O resident -O no-touch-required -O user=smaier-bio -O application=ssh:sign -C "yubikeyBio-git-sign-1-$(date +'%Y-%m-%d')" -f ~/.ssh/id_ed25519_sk_sign_bio
# Generate sign key for Security Key:
ssh-keygen -t ed25519-sk -O resident -O no-touch-required -O user=smaier-sk1 -O application=ssh:sign -C "yubikeySK1-git-sign-1-$(date +'%Y-%m-%d')" -f ~/.ssh/id_ed25519_sk_sign_sk1

# Add resident key(s?) to device temporarily (needs active ssh-agent: `ssh-agent -s`):
ssh-add -K
# Add resident key(s?) to device permanently:
ssh-keygen  -K

# list keys installed on token (needs yubikey-manager):
ykman fido credentials list
```

To use git commit signing:

Adjust git settings:

```toml
# ~/.gitconfig
[commit]
	gpgsign = true
[gpg]
	format = ssh
[gpg "ssh"]
	allowedSignersFile = ~/.ssh/allowed_signers
	# find a key that has its hardware-token plugged in
	# defaultKeyCommand = ~/.config/git/find_active_key
[user]
	# look up dynamically (TODO)
	signingKey = ~/.ssh/id_ed25519_sk_sign_bio
```

Add allowedSigners to validate on your PC (you need to add every key, also of collegues, that is allowed to sign, and for what identities):

```
# replace example emails, add to ~/.ssh/allowed_signers
# generate:
# email1[,email2,...] $(key.pub)
# explainer:
# -----emails to verify --- |THIS IS NOT AN EMAIL BUT THE KEYTYPE, ssh-ed25519-sk fails |keys | ignored
1@example.de,2@otherhost.net sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAogDGdG+aTRebj7b8geslJajkM9+w3/baKYC/ENM1MWAAAACnNzaDphY2Nlc3M= yubikeyBio-access-1-2022-10-31
```
At least with YubiKey Bio:

**On every boot** make these keys present with `ssh-add -K`, otherwise commits will fail to sign correctly (they will fail to work without key present with it present itll look like it works but commit will have faulty signature, only after `ssh-add -K`).

Yet to experiment with `ssh-keygen -K`