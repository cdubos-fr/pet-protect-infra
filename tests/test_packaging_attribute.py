import pytest

from .utils import is_canonical_version


class TestPackagingAttribute:
    @pytest.mark.unit
    def test_version_respect_pep440(self) -> None:
        from pet_protect_infra import __version__

        assert isinstance(__version__, str)
        assert is_canonical_version(__version__)

    @pytest.mark.unit
    def test_package_description(self) -> None:
        from pet_protect_infra import __doc__ as doc

        assert isinstance(doc, str)
        assert len(doc) > 0
