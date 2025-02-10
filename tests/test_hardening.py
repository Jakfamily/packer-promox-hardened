import testinfra

def test_user_debian_exists(host):
    user = host.user("debian")
    assert user.exists, "L'utilisateur debian devrait exister"
