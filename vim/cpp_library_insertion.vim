functnion! CppLibraryInsertion(inputfile) abort
    let numl = CppFileParse(expand("%:r")) " parse current working file
    let linum = numl[2]

    for line in readfile(inputfile)
        if line == "//===" && isInsertState == 0
            let isInsertState = 1
        endif
        if line == "//===" && isInsertState == 1
            break;
        endif
        if isInsertState == 1
            execute ":" . linum
            execute ":normal o " . line
            let linum = linum + 1
        endif
    endfor

endfunction

function! CppFileParse(inputfile) abort " [0]:.h [1]:declaration [2]:library
    let x = 1
    let head
    let decl
    let lib

    for line in readfile(inputfile)
        if line == "// header file section"
            head = x;
        endif
        if line == "// declaration section"
            decl = x;
        endif
        if line == "// library section"
            lib = x;
        endif
        x++
    endfor
    
    return [head, decl, lib]
endfunction
