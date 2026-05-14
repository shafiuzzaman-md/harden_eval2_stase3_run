; ModuleID = 'out/eval2_linux/path_a/kbmp_line165/harness.bc'
source_filename = "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_kbmp_line165.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [63 x i8] c"/home/shafi/tools/klee/runtime/Intrinsic/klee_div_zero_check.c\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @rotate(i8* noundef %0, i64 noundef %1) #0 !dbg !22 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !27, metadata !DIExpression()), !dbg !28
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !29, metadata !DIExpression()), !dbg !30
  call void @llvm.dbg.declare(metadata i64* %6, metadata !31, metadata !DIExpression()), !dbg !32
  %10 = load i8*, i8** %4, align 8, !dbg !33
  %11 = call i64 @strlen(i8* noundef %10) #9, !dbg !34
  store i64 %11, i64* %6, align 8, !dbg !32
  call void @llvm.dbg.declare(metadata i8** %7, metadata !35, metadata !DIExpression()), !dbg !36
  %12 = load i64, i64* %6, align 8, !dbg !37
  %13 = add i64 %12, 1, !dbg !37
  %14 = call noalias i8* @malloc(i64 noundef %13) #10, !dbg !37
  store i8* %14, i8** %7, align 8, !dbg !36
  %15 = load i8*, i8** %7, align 8, !dbg !38
  %16 = icmp ne i8* %15, null, !dbg !38
  br i1 %16, label %18, label %17, !dbg !40

17:                                               ; preds = %2
  store i8* null, i8** %3, align 8, !dbg !41
  br label %41, !dbg !41

18:                                               ; preds = %2
  call void @llvm.dbg.declare(metadata i64* %8, metadata !43, metadata !DIExpression()), !dbg !44
  %19 = load i64, i64* %5, align 8, !dbg !45
  %20 = load i64, i64* %6, align 8, !dbg !46
  call void @klee_div_zero_check(i64 %20), !dbg !47
  %21 = urem i64 %19, %20, !dbg !47, !klee.check.div !48
  store i64 %21, i64* %8, align 8, !dbg !44
  call void @llvm.dbg.declare(metadata i64* %9, metadata !49, metadata !DIExpression()), !dbg !50
  %22 = load i64, i64* %6, align 8, !dbg !51
  %23 = load i64, i64* %8, align 8, !dbg !52
  %24 = sub i64 %22, %23, !dbg !53
  store i64 %24, i64* %9, align 8, !dbg !50
  %25 = load i8*, i8** %7, align 8, !dbg !54
  %26 = load i8*, i8** %4, align 8, !dbg !55
  %27 = load i64, i64* %8, align 8, !dbg !56
  %28 = getelementptr inbounds i8, i8* %26, i64 %27, !dbg !57
  %29 = load i64, i64* %9, align 8, !dbg !58
  %30 = call i8* @memcpy(i8* %25, i8* %28, i64 %29), !dbg !59
  %31 = load i8*, i8** %7, align 8, !dbg !60
  %32 = load i64, i64* %9, align 8, !dbg !61
  %33 = getelementptr inbounds i8, i8* %31, i64 %32, !dbg !62
  %34 = load i8*, i8** %4, align 8, !dbg !63
  %35 = load i64, i64* %8, align 8, !dbg !64
  %36 = call i8* @memcpy(i8* %33, i8* %34, i64 %35), !dbg !65
  %37 = load i8*, i8** %7, align 8, !dbg !66
  %38 = load i64, i64* %6, align 8, !dbg !67
  %39 = getelementptr inbounds i8, i8* %37, i64 %38, !dbg !66
  store i8 0, i8* %39, align 1, !dbg !68
  %40 = load i8*, i8** %7, align 8, !dbg !69
  store i8* %40, i8** %3, align 8, !dbg !70
  br label %41, !dbg !70

41:                                               ; preds = %18, %17
  %42 = load i8*, i8** %3, align 8, !dbg !71
  ret i8* %42, !dbg !71
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind readonly willreturn
declare i64 @strlen(i8* noundef) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !72 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca [1 x i8], align 1
  %4 = alloca i8*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !76, metadata !DIExpression()), !dbg !77
  %5 = bitcast i64* %2 to i8*, !dbg !78
  call void @klee_make_symbolic(i8* noundef %5, i64 noundef 8, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0)), !dbg !79
  %6 = load i64, i64* %2, align 8, !dbg !80
  %7 = icmp ult i64 %6, 4294967296, !dbg !81
  %8 = zext i1 %7 to i32, !dbg !81
  %9 = sext i32 %8 to i64, !dbg !80
  call void @klee_assume(i64 noundef %9), !dbg !82
  call void @llvm.dbg.declare(metadata [1 x i8]* %3, metadata !83, metadata !DIExpression()), !dbg !87
  %10 = bitcast [1 x i8]* %3 to i8*, !dbg !87
  %11 = call i8* @memset(i8* %10, i32 0, i64 1), !dbg !87
  call void @llvm.dbg.declare(metadata i8** %4, metadata !88, metadata !DIExpression()), !dbg !89
  %12 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i64 0, i64 0, !dbg !90
  %13 = load i64, i64* %2, align 8, !dbg !91
  %14 = call i8* @rotate(i8* noundef %12, i64 noundef %13), !dbg !92
  store i8* %14, i8** %4, align 8, !dbg !89
  %15 = load i8*, i8** %4, align 8, !dbg !93
  %16 = icmp ne i8* %15, null, !dbg !93
  br i1 %16, label %17, label %19, !dbg !95

17:                                               ; preds = %0
  %18 = load i8*, i8** %4, align 8, !dbg !96
  call void @free(i8* noundef %18) #10, !dbg !98
  br label %19, !dbg !99

19:                                               ; preds = %17, %0
  ret i32 0, !dbg !100
}

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #5

declare void @klee_assume(i64 noundef) #5

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #6

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memcpy(i8* noundef %0, i8* noundef %1, i64 noundef %2) #7 !dbg !101 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !108, metadata !DIExpression()), !dbg !109
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !110, metadata !DIExpression()), !dbg !111
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !112, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.declare(metadata i8** %7, metadata !114, metadata !DIExpression()), !dbg !115
  %9 = load i8*, i8** %4, align 8, !dbg !116
  store i8* %9, i8** %7, align 8, !dbg !115
  call void @llvm.dbg.declare(metadata i8** %8, metadata !117, metadata !DIExpression()), !dbg !120
  %10 = load i8*, i8** %5, align 8, !dbg !121
  store i8* %10, i8** %8, align 8, !dbg !120
  br label %11, !dbg !122

11:                                               ; preds = %15, %3
  %12 = load i64, i64* %6, align 8, !dbg !123
  %13 = add i64 %12, -1, !dbg !123
  store i64 %13, i64* %6, align 8, !dbg !123
  %14 = icmp ugt i64 %12, 0, !dbg !124
  br i1 %14, label %15, label %21, !dbg !122

15:                                               ; preds = %11
  %16 = load i8*, i8** %8, align 8, !dbg !125
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !125
  store i8* %17, i8** %8, align 8, !dbg !125
  %18 = load i8, i8* %16, align 1, !dbg !126
  %19 = load i8*, i8** %7, align 8, !dbg !127
  %20 = getelementptr inbounds i8, i8* %19, i32 1, !dbg !127
  store i8* %20, i8** %7, align 8, !dbg !127
  store i8 %18, i8* %19, align 1, !dbg !128
  br label %11, !dbg !122, !llvm.loop !129

21:                                               ; preds = %11
  %22 = load i8*, i8** %4, align 8, !dbg !131
  ret i8* %22, !dbg !132
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memset(i8* noundef %0, i32 noundef %1, i64 noundef %2) #7 !dbg !133 {
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !137, metadata !DIExpression()), !dbg !138
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !139, metadata !DIExpression()), !dbg !140
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !141, metadata !DIExpression()), !dbg !142
  call void @llvm.dbg.declare(metadata i8** %7, metadata !143, metadata !DIExpression()), !dbg !144
  %8 = load i8*, i8** %4, align 8, !dbg !145
  store i8* %8, i8** %7, align 8, !dbg !144
  br label %9, !dbg !146

9:                                                ; preds = %13, %3
  %10 = load i64, i64* %6, align 8, !dbg !147
  %11 = add i64 %10, -1, !dbg !147
  store i64 %11, i64* %6, align 8, !dbg !147
  %12 = icmp ugt i64 %10, 0, !dbg !148
  br i1 %12, label %13, label %18, !dbg !146

13:                                               ; preds = %9
  %14 = load i32, i32* %5, align 4, !dbg !149
  %15 = trunc i32 %14 to i8, !dbg !149
  %16 = load i8*, i8** %7, align 8, !dbg !150
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !150
  store i8* %17, i8** %7, align 8, !dbg !150
  store i8 %15, i8* %16, align 1, !dbg !151
  br label %9, !dbg !146, !llvm.loop !152

18:                                               ; preds = %9
  %19 = load i8*, i8** %4, align 8, !dbg !153
  ret i8* %19, !dbg !154
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @klee_div_zero_check(i64 noundef %0) #7 !dbg !155 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !160, metadata !DIExpression()), !dbg !161
  %3 = load i64, i64* %2, align 8, !dbg !162
  %4 = icmp eq i64 %3, 0, !dbg !164
  br i1 %4, label %5, label %6, !dbg !165

5:                                                ; preds = %1
  call void @klee_report_error(i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.7, i64 0, i64 0), i32 noundef 14, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i64 0, i64 0)) #11, !dbg !166
  unreachable, !dbg !166

6:                                                ; preds = %1
  ret void, !dbg !167
}

; Function Attrs: noreturn
declare void @klee_report_error(i8* noundef, i32 noundef, i8* noundef, i8* noundef) #8

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly willreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { argmemonly nofree nounwind willreturn }
attributes #5 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { argmemonly nofree nounwind willreturn writeonly }
attributes #7 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { nounwind readonly willreturn }
attributes #10 = { nounwind }
attributes #11 = { noreturn }

!llvm.dbg.cu = !{!0, !8, !10, !12}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21, !21, !21, !21}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_kbmp_line165.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "b516593ed1961cfb9e25fe60925d96f0")
!2 = !{!3, !5}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !6, line: 46, baseType: !7)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!7 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!8 = distinct !DICompileUnit(language: DW_LANG_C99, file: !9, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!10 = distinct !DICompileUnit(language: DW_LANG_C99, file: !11, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!11 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memset.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "f66ef9ef9131ab198e93a41b1a9ae1fc")
!12 = distinct !DICompileUnit(language: DW_LANG_C89, file: !13, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Intrinsic/klee_div_zero_check.c", directory: "/home/shafi/tools/klee/build/runtime/Intrinsic", checksumkind: CSK_MD5, checksum: "ac97458b4bebcea5cefe50ebb216db13")
!14 = !{i32 7, !"Dwarf Version", i32 5}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 7, !"PIC Level", i32 2}
!18 = !{i32 7, !"PIE Level", i32 2}
!19 = !{i32 7, !"uwtable", i32 1}
!20 = !{i32 7, !"frame-pointer", i32 2}
!21 = !{!"Ubuntu clang version 14.0.6"}
!22 = distinct !DISubprogram(name: "rotate", scope: !23, file: !23, line: 158, type: !24, scopeLine: 158, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !26)
!23 = !DIFile(filename: "kbmp.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!24 = !DISubroutineType(types: !25)
!25 = !{!3, !3, !5}
!26 = !{}
!27 = !DILocalVariable(name: "s", arg: 1, scope: !22, file: !23, line: 158, type: !3)
!28 = !DILocation(line: 158, column: 20, scope: !22)
!29 = !DILocalVariable(name: "i", arg: 2, scope: !22, file: !23, line: 158, type: !5)
!30 = !DILocation(line: 158, column: 30, scope: !22)
!31 = !DILocalVariable(name: "length", scope: !22, file: !23, line: 159, type: !5)
!32 = !DILocation(line: 159, column: 12, scope: !22)
!33 = !DILocation(line: 159, column: 28, scope: !22)
!34 = !DILocation(line: 159, column: 21, scope: !22)
!35 = !DILocalVariable(name: "rotated", scope: !22, file: !23, line: 160, type: !3)
!36 = !DILocation(line: 160, column: 11, scope: !22)
!37 = !DILocation(line: 160, column: 28, scope: !22)
!38 = !DILocation(line: 161, column: 10, scope: !39)
!39 = distinct !DILexicalBlock(scope: !22, file: !23, line: 161, column: 9)
!40 = !DILocation(line: 161, column: 9, scope: !22)
!41 = !DILocation(line: 162, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !39, file: !23, line: 161, column: 19)
!43 = !DILocalVariable(name: "index", scope: !22, file: !23, line: 165, type: !5)
!44 = !DILocation(line: 165, column: 12, scope: !22)
!45 = !DILocation(line: 165, column: 20, scope: !22)
!46 = !DILocation(line: 165, column: 24, scope: !22)
!47 = !DILocation(line: 165, column: 22, scope: !22)
!48 = !{!"True"}
!49 = !DILocalVariable(name: "remainder_length", scope: !22, file: !23, line: 166, type: !5)
!50 = !DILocation(line: 166, column: 12, scope: !22)
!51 = !DILocation(line: 166, column: 31, scope: !22)
!52 = !DILocation(line: 166, column: 40, scope: !22)
!53 = !DILocation(line: 166, column: 38, scope: !22)
!54 = !DILocation(line: 168, column: 12, scope: !22)
!55 = !DILocation(line: 168, column: 21, scope: !22)
!56 = !DILocation(line: 168, column: 25, scope: !22)
!57 = !DILocation(line: 168, column: 23, scope: !22)
!58 = !DILocation(line: 168, column: 32, scope: !22)
!59 = !DILocation(line: 168, column: 5, scope: !22)
!60 = !DILocation(line: 169, column: 12, scope: !22)
!61 = !DILocation(line: 169, column: 22, scope: !22)
!62 = !DILocation(line: 169, column: 20, scope: !22)
!63 = !DILocation(line: 169, column: 40, scope: !22)
!64 = !DILocation(line: 169, column: 43, scope: !22)
!65 = !DILocation(line: 169, column: 5, scope: !22)
!66 = !DILocation(line: 171, column: 5, scope: !22)
!67 = !DILocation(line: 171, column: 13, scope: !22)
!68 = !DILocation(line: 171, column: 21, scope: !22)
!69 = !DILocation(line: 172, column: 12, scope: !22)
!70 = !DILocation(line: 172, column: 5, scope: !22)
!71 = !DILocation(line: 173, column: 1, scope: !22)
!72 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 175, type: !73, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !26)
!73 = !DISubroutineType(types: !74)
!74 = !{!75}
!75 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!76 = !DILocalVariable(name: "i", scope: !72, file: !23, line: 176, type: !5)
!77 = !DILocation(line: 176, column: 12, scope: !72)
!78 = !DILocation(line: 179, column: 24, scope: !72)
!79 = !DILocation(line: 179, column: 5, scope: !72)
!80 = !DILocation(line: 180, column: 17, scope: !72)
!81 = !DILocation(line: 180, column: 19, scope: !72)
!82 = !DILocation(line: 180, column: 5, scope: !72)
!83 = !DILocalVariable(name: "empty", scope: !72, file: !23, line: 185, type: !84)
!84 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 8, elements: !85)
!85 = !{!86}
!86 = !DISubrange(count: 1)
!87 = !DILocation(line: 185, column: 10, scope: !72)
!88 = !DILocalVariable(name: "r", scope: !72, file: !23, line: 186, type: !3)
!89 = !DILocation(line: 186, column: 11, scope: !72)
!90 = !DILocation(line: 186, column: 22, scope: !72)
!91 = !DILocation(line: 186, column: 29, scope: !72)
!92 = !DILocation(line: 186, column: 15, scope: !72)
!93 = !DILocation(line: 187, column: 9, scope: !94)
!94 = distinct !DILexicalBlock(scope: !72, file: !23, line: 187, column: 9)
!95 = !DILocation(line: 187, column: 9, scope: !72)
!96 = !DILocation(line: 188, column: 14, scope: !97)
!97 = distinct !DILexicalBlock(scope: !94, file: !23, line: 187, column: 12)
!98 = !DILocation(line: 188, column: 9, scope: !97)
!99 = !DILocation(line: 189, column: 5, scope: !97)
!100 = !DILocation(line: 190, column: 5, scope: !72)
!101 = distinct !DISubprogram(name: "memcpy", scope: !102, file: !102, line: 12, type: !103, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !26)
!102 = !DIFile(filename: "runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!103 = !DISubroutineType(types: !104)
!104 = !{!105, !105, !106, !5}
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!108 = !DILocalVariable(name: "destaddr", arg: 1, scope: !101, file: !102, line: 12, type: !105)
!109 = !DILocation(line: 12, column: 20, scope: !101)
!110 = !DILocalVariable(name: "srcaddr", arg: 2, scope: !101, file: !102, line: 12, type: !106)
!111 = !DILocation(line: 12, column: 42, scope: !101)
!112 = !DILocalVariable(name: "len", arg: 3, scope: !101, file: !102, line: 12, type: !5)
!113 = !DILocation(line: 12, column: 58, scope: !101)
!114 = !DILocalVariable(name: "dest", scope: !101, file: !102, line: 13, type: !3)
!115 = !DILocation(line: 13, column: 9, scope: !101)
!116 = !DILocation(line: 13, column: 16, scope: !101)
!117 = !DILocalVariable(name: "src", scope: !101, file: !102, line: 14, type: !118)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!120 = !DILocation(line: 14, column: 15, scope: !101)
!121 = !DILocation(line: 14, column: 21, scope: !101)
!122 = !DILocation(line: 16, column: 3, scope: !101)
!123 = !DILocation(line: 16, column: 13, scope: !101)
!124 = !DILocation(line: 16, column: 16, scope: !101)
!125 = !DILocation(line: 17, column: 19, scope: !101)
!126 = !DILocation(line: 17, column: 15, scope: !101)
!127 = !DILocation(line: 17, column: 10, scope: !101)
!128 = !DILocation(line: 17, column: 13, scope: !101)
!129 = distinct !{!129, !122, !125, !130}
!130 = !{!"llvm.loop.mustprogress"}
!131 = !DILocation(line: 18, column: 10, scope: !101)
!132 = !DILocation(line: 18, column: 3, scope: !101)
!133 = distinct !DISubprogram(name: "memset", scope: !134, file: !134, line: 12, type: !135, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !10, retainedNodes: !26)
!134 = !DIFile(filename: "runtime/Freestanding/memset.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "f66ef9ef9131ab198e93a41b1a9ae1fc")
!135 = !DISubroutineType(types: !136)
!136 = !{!105, !105, !75, !5}
!137 = !DILocalVariable(name: "dst", arg: 1, scope: !133, file: !134, line: 12, type: !105)
!138 = !DILocation(line: 12, column: 20, scope: !133)
!139 = !DILocalVariable(name: "s", arg: 2, scope: !133, file: !134, line: 12, type: !75)
!140 = !DILocation(line: 12, column: 29, scope: !133)
!141 = !DILocalVariable(name: "count", arg: 3, scope: !133, file: !134, line: 12, type: !5)
!142 = !DILocation(line: 12, column: 39, scope: !133)
!143 = !DILocalVariable(name: "a", scope: !133, file: !134, line: 13, type: !3)
!144 = !DILocation(line: 13, column: 9, scope: !133)
!145 = !DILocation(line: 13, column: 13, scope: !133)
!146 = !DILocation(line: 14, column: 3, scope: !133)
!147 = !DILocation(line: 14, column: 15, scope: !133)
!148 = !DILocation(line: 14, column: 18, scope: !133)
!149 = !DILocation(line: 15, column: 12, scope: !133)
!150 = !DILocation(line: 15, column: 7, scope: !133)
!151 = !DILocation(line: 15, column: 10, scope: !133)
!152 = distinct !{!152, !146, !149, !130}
!153 = !DILocation(line: 16, column: 10, scope: !133)
!154 = !DILocation(line: 16, column: 3, scope: !133)
!155 = distinct !DISubprogram(name: "klee_div_zero_check", scope: !156, file: !156, line: 12, type: !157, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !26)
!156 = !DIFile(filename: "runtime/Intrinsic/klee_div_zero_check.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "ac97458b4bebcea5cefe50ebb216db13")
!157 = !DISubroutineType(types: !158)
!158 = !{null, !159}
!159 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!160 = !DILocalVariable(name: "z", arg: 1, scope: !155, file: !156, line: 12, type: !159)
!161 = !DILocation(line: 12, column: 36, scope: !155)
!162 = !DILocation(line: 13, column: 7, scope: !163)
!163 = distinct !DILexicalBlock(scope: !155, file: !156, line: 13, column: 7)
!164 = !DILocation(line: 13, column: 9, scope: !163)
!165 = !DILocation(line: 13, column: 7, scope: !155)
!166 = !DILocation(line: 14, column: 5, scope: !163)
!167 = !DILocation(line: 15, column: 1, scope: !155)
