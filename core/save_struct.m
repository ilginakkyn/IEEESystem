function save_struct(f, S)
%SAVE_STRUCT  MATLAB ve Octave'da aynı biçimde (v7 .mat) kaydeder.
if exist('OCTAVE_VERSION','builtin')
    save('-v7', f, 'S');
else
    save(f, 'S', '-v7');
end
end
