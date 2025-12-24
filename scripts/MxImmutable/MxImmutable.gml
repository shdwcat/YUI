/// @description base struct that marks anything inheriting from it as immutable
///				 which means attempting to modify it with e.g. YuiSetValue and
///				 YuiSetIndex will throw an error
function MxImmutable() constructor {}

/// @description checks if the given struct is considered immutable
function mx_is_immutable(struct) {
	return is_instanceof(struct, MxImmutable);
}