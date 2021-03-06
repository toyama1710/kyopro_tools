let s:prefix = $KYOPROHOME . "/cpp_library/"

" [0]:.h [1]:declaration [2]:library
function! CppFileParse(inputfile) abort
    let x = 1
    let head = -1
    let decl = -1
    let lib = -1

    for line in readfile(a:inputfile)
        if line == "// header file section"
            let head = x
        elseif line == "// declaration section"
            let decl = x
        elseif line == "// library section"
            let lib = x
        endif
        let x = x + 1
    endfor
    
    return [head, decl, lib]
endfunction

function InsertCppLibraryf(arg) abort
    let retrow = line(".")
    let retcol = col(".")
    let insertfile = a:arg

    if filereadable(insertfile) == 0 && filereadable(s:prefix . insertfile) == 1
        let insertfile = s:prefix . insertfile
    endif

    if filereadable(insertfile) == 0
        echo "file not found"
        return
    endif
    
    execute ":w"
    let numl = CppFileParse(expand("%:p")) "parse current working file
    let linum = numl[2]
    let isInsertState = 0

    call append(linum, "")
    let linum = linum + 1
    for line in readfile(insertfile)
        if line == "//===" && isInsertState == 0
            let isInsertState = 1
        elseif line == "//===" && isInsertState == 1
            break
        elseif isInsertState == 1
            execute ":" . linum
            execute ":normal o" . line
            execute ":normal =="
            let linum = linum + 1
        endif
    endfor
    call append(linum, "")

    call cursor(retrow, retcol)

endfunction

function! CompCppLibrary(lead, line, pos)
    let keyw = s:prefix . a:lead
    let wlist = split(glob(keyw . "*"), "\n")

    let i = 0

    for s in wlist
        let wlist[i] = substitute(s, s:prefix, "", "g")
        let i = i + 1
    endfor

    return wlist
endfunction

command! -nargs=1 -complete=customlist,CompCppLibrary InsertCppLibrary call InsertCppLibraryf(<f-args>)
