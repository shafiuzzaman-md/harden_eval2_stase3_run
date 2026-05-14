; ModuleID = 'out/eval2_linux/path_a/usb_event_logger_line118/harness.bc'
source_filename = "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_usb_event_logger_line118.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.notifier_block = type { i32 (%struct.notifier_block*, i64, i8*)*, %struct.notifier_block*, i32 }

@.str = private unnamed_addr constant [7 x i8] c"action\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"dev_bits\00", align 1
@g_usb_notifier_chain = internal global %struct.notifier_block* null, align 8, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !28 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca %struct.notifier_block*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !33, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i64* %3, metadata !35, metadata !DIExpression()), !dbg !38
  %5 = bitcast i64* %2 to i8*, !dbg !39
  call void @klee_make_symbolic(i8* noundef %5, i64 noundef 8, i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0)), !dbg !40
  %6 = bitcast i64* %3 to i8*, !dbg !41
  call void @klee_make_symbolic(i8* noundef %6, i64 noundef 8, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0)), !dbg !42
  %7 = load i64, i64* %2, align 8, !dbg !43
  %8 = icmp ult i64 %7, 4294967296, !dbg !44
  %9 = zext i1 %8 to i32, !dbg !44
  %10 = sext i32 %9 to i64, !dbg !43
  call void @klee_assume(i64 noundef %10), !dbg !45
  %11 = load i64, i64* %3, align 8, !dbg !46
  %12 = icmp eq i64 %11, 0, !dbg !47
  %13 = zext i1 %12 to i32, !dbg !47
  %14 = sext i32 %13 to i64, !dbg !46
  call void @klee_assume(i64 noundef %14), !dbg !48
  call void @llvm.dbg.declare(metadata %struct.notifier_block** %4, metadata !49, metadata !DIExpression()), !dbg !50
  %15 = call noalias i8* @malloc(i64 noundef 24) #4, !dbg !51
  %16 = bitcast i8* %15 to %struct.notifier_block*, !dbg !52
  store %struct.notifier_block* %16, %struct.notifier_block** %4, align 8, !dbg !50
  %17 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !53
  %18 = icmp ne %struct.notifier_block* %17, null, !dbg !53
  br i1 %18, label %20, label %19, !dbg !55

19:                                               ; preds = %0
  store i32 1, i32* %1, align 4, !dbg !56
  br label %34, !dbg !56

20:                                               ; preds = %0
  %21 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !57
  %22 = getelementptr inbounds %struct.notifier_block, %struct.notifier_block* %21, i32 0, i32 0, !dbg !58
  store i32 (%struct.notifier_block*, i64, i8*)* @usb_notify, i32 (%struct.notifier_block*, i64, i8*)** %22, align 8, !dbg !59
  %23 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !60
  %24 = getelementptr inbounds %struct.notifier_block, %struct.notifier_block* %23, i32 0, i32 1, !dbg !61
  store %struct.notifier_block* null, %struct.notifier_block** %24, align 8, !dbg !62
  %25 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !63
  %26 = getelementptr inbounds %struct.notifier_block, %struct.notifier_block* %25, i32 0, i32 2, !dbg !64
  store i32 0, i32* %26, align 8, !dbg !65
  %27 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !66
  call void @usb_register_notify(%struct.notifier_block* noundef %27), !dbg !67
  %28 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !68
  %29 = bitcast %struct.notifier_block* %28 to i8*, !dbg !68
  call void @free(i8* noundef %29) #4, !dbg !68
  call void @usb_logger_exit_buggy(), !dbg !69
  %30 = load i64, i64* %2, align 8, !dbg !70
  %31 = load i64, i64* %3, align 8, !dbg !71
  %32 = inttoptr i64 %31 to i8*, !dbg !72
  %33 = call i32 @deliver_usb_event(i64 noundef %30, i8* noundef %32), !dbg !73
  store i32 0, i32* %1, align 4, !dbg !74
  br label %34, !dbg !74

34:                                               ; preds = %20, %19
  %35 = load i32, i32* %1, align 4, !dbg !75
  ret i32 %35, !dbg !75
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #2

declare void @klee_assume(i64 noundef) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @usb_notify(%struct.notifier_block* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !76 {
  %4 = alloca %struct.notifier_block*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store %struct.notifier_block* %0, %struct.notifier_block** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.notifier_block** %4, metadata !77, metadata !DIExpression()), !dbg !78
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !79, metadata !DIExpression()), !dbg !80
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !81, metadata !DIExpression()), !dbg !82
  %7 = load %struct.notifier_block*, %struct.notifier_block** %4, align 8, !dbg !83
  %8 = load i8*, i8** %6, align 8, !dbg !84
  %9 = load i64, i64* %5, align 8, !dbg !85
  switch i64 %9, label %16 [
    i64 1, label %10
    i64 2, label %13
  ], !dbg !86

10:                                               ; preds = %3
  br label %11, !dbg !87

11:                                               ; preds = %10
  br label %12, !dbg !89

12:                                               ; preds = %11
  br label %19, !dbg !91

13:                                               ; preds = %3
  br label %14, !dbg !92

14:                                               ; preds = %13
  br label %15, !dbg !93

15:                                               ; preds = %14
  br label %19, !dbg !95

16:                                               ; preds = %3
  br label %17, !dbg !96

17:                                               ; preds = %16
  br label %18, !dbg !97

18:                                               ; preds = %17
  br label %19, !dbg !99

19:                                               ; preds = %18, %15, %12
  ret i32 1, !dbg !100
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @usb_register_notify(%struct.notifier_block* noundef %0) #0 !dbg !101 {
  %2 = alloca %struct.notifier_block*, align 8
  store %struct.notifier_block* %0, %struct.notifier_block** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.notifier_block** %2, metadata !104, metadata !DIExpression()), !dbg !105
  %3 = load %struct.notifier_block*, %struct.notifier_block** %2, align 8, !dbg !106
  store %struct.notifier_block* %3, %struct.notifier_block** @g_usb_notifier_chain, align 8, !dbg !107
  ret void, !dbg !108
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @usb_logger_exit_buggy() #0 !dbg !109 {
  ret void, !dbg !112
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @deliver_usb_event(i64 noundef %0, i8* noundef %1) #0 !dbg !113 {
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i8*, align 8
  %6 = alloca %struct.notifier_block*, align 8
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !116, metadata !DIExpression()), !dbg !117
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata %struct.notifier_block** %6, metadata !120, metadata !DIExpression()), !dbg !121
  %7 = load %struct.notifier_block*, %struct.notifier_block** @g_usb_notifier_chain, align 8, !dbg !122
  store %struct.notifier_block* %7, %struct.notifier_block** %6, align 8, !dbg !121
  %8 = load %struct.notifier_block*, %struct.notifier_block** %6, align 8, !dbg !123
  %9 = icmp ne %struct.notifier_block* %8, null, !dbg !123
  br i1 %9, label %11, label %10, !dbg !125

10:                                               ; preds = %2
  store i32 0, i32* %3, align 4, !dbg !126
  br label %19, !dbg !126

11:                                               ; preds = %2
  %12 = load %struct.notifier_block*, %struct.notifier_block** %6, align 8, !dbg !127
  %13 = getelementptr inbounds %struct.notifier_block, %struct.notifier_block* %12, i32 0, i32 0, !dbg !129
  %14 = load i32 (%struct.notifier_block*, i64, i8*)*, i32 (%struct.notifier_block*, i64, i8*)** %13, align 8, !dbg !129
  %15 = load %struct.notifier_block*, %struct.notifier_block** %6, align 8, !dbg !130
  %16 = load i64, i64* %4, align 8, !dbg !131
  %17 = load i8*, i8** %5, align 8, !dbg !132
  %18 = call i32 %14(%struct.notifier_block* noundef %15, i64 noundef %16, i8* noundef %17), !dbg !127
  store i32 %18, i32* %3, align 4, !dbg !133
  br label %19, !dbg !133

19:                                               ; preds = %11, %10
  %20 = load i32, i32* %3, align 4, !dbg !134
  ret i32 %20, !dbg !134
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}
!llvm.ident = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_usb_notifier_chain", scope: !2, file: !8, line: 64, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_usb_event_logger_line118.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "792326c4d7ab77801011627444cc02c9")
!4 = !{!5, !6, !16}
!5 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "notifier_block", file: !8, line: 57, size: 192, elements: !9)
!8 = !DIFile(filename: "out/eval2_linux/harnesses/harness_usb_event_logger_line118.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "792326c4d7ab77801011627444cc02c9")
!9 = !{!10, !17, !18}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "notifier_call", scope: !7, file: !8, line: 58, baseType: !11, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "notifier_fn_t", file: !8, line: 55, baseType: !12)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DISubroutineType(types: !14)
!14 = !{!15, !6, !5, !16}
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !7, file: !8, line: 59, baseType: !6, size: 64, offset: 64)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !7, file: !8, line: 60, baseType: !15, size: 32, offset: 128)
!19 = !{!0}
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 7, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = !{!"Ubuntu clang version 14.0.6"}
!28 = distinct !DISubprogram(name: "main", scope: !29, file: !29, line: 127, type: !30, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !32)
!29 = !DIFile(filename: "usb_event_logger.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!30 = !DISubroutineType(types: !31)
!31 = !{!15}
!32 = !{}
!33 = !DILocalVariable(name: "action", scope: !28, file: !29, line: 129, type: !5)
!34 = !DILocation(line: 129, column: 19, scope: !28)
!35 = !DILocalVariable(name: "dev_bits", scope: !28, file: !29, line: 130, type: !36)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !37, line: 79, baseType: !5)
!37 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "bfb03fa9c46a839e35c32b929fbdbb8e")
!38 = !DILocation(line: 130, column: 15, scope: !28)
!39 = !DILocation(line: 133, column: 24, scope: !28)
!40 = !DILocation(line: 133, column: 5, scope: !28)
!41 = !DILocation(line: 134, column: 24, scope: !28)
!42 = !DILocation(line: 134, column: 5, scope: !28)
!43 = !DILocation(line: 135, column: 17, scope: !28)
!44 = !DILocation(line: 135, column: 24, scope: !28)
!45 = !DILocation(line: 135, column: 5, scope: !28)
!46 = !DILocation(line: 136, column: 17, scope: !28)
!47 = !DILocation(line: 136, column: 26, scope: !28)
!48 = !DILocation(line: 136, column: 5, scope: !28)
!49 = !DILocalVariable(name: "usb_nb", scope: !28, file: !29, line: 144, type: !6)
!50 = !DILocation(line: 144, column: 28, scope: !28)
!51 = !DILocation(line: 145, column: 34, scope: !28)
!52 = !DILocation(line: 145, column: 9, scope: !28)
!53 = !DILocation(line: 146, column: 10, scope: !54)
!54 = distinct !DILexicalBlock(scope: !28, file: !29, line: 146, column: 9)
!55 = !DILocation(line: 146, column: 9, scope: !28)
!56 = !DILocation(line: 147, column: 9, scope: !54)
!57 = !DILocation(line: 148, column: 5, scope: !28)
!58 = !DILocation(line: 148, column: 13, scope: !28)
!59 = !DILocation(line: 148, column: 27, scope: !28)
!60 = !DILocation(line: 149, column: 5, scope: !28)
!61 = !DILocation(line: 149, column: 13, scope: !28)
!62 = !DILocation(line: 149, column: 27, scope: !28)
!63 = !DILocation(line: 150, column: 5, scope: !28)
!64 = !DILocation(line: 150, column: 13, scope: !28)
!65 = !DILocation(line: 150, column: 27, scope: !28)
!66 = !DILocation(line: 153, column: 25, scope: !28)
!67 = !DILocation(line: 153, column: 5, scope: !28)
!68 = !DILocation(line: 157, column: 5, scope: !28)
!69 = !DILocation(line: 158, column: 5, scope: !28)
!70 = !DILocation(line: 161, column: 29, scope: !28)
!71 = !DILocation(line: 161, column: 45, scope: !28)
!72 = !DILocation(line: 161, column: 37, scope: !28)
!73 = !DILocation(line: 161, column: 11, scope: !28)
!74 = !DILocation(line: 163, column: 5, scope: !28)
!75 = !DILocation(line: 164, column: 1, scope: !28)
!76 = distinct !DISubprogram(name: "usb_notify", scope: !8, file: !8, line: 78, type: !13, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !32)
!77 = !DILocalVariable(name: "self", arg: 1, scope: !76, file: !8, line: 78, type: !6)
!78 = !DILocation(line: 78, column: 46, scope: !76)
!79 = !DILocalVariable(name: "action", arg: 2, scope: !76, file: !8, line: 78, type: !5)
!80 = !DILocation(line: 78, column: 66, scope: !76)
!81 = !DILocalVariable(name: "dev", arg: 3, scope: !76, file: !8, line: 78, type: !16)
!82 = !DILocation(line: 78, column: 80, scope: !76)
!83 = !DILocation(line: 80, column: 11, scope: !76)
!84 = !DILocation(line: 80, column: 23, scope: !76)
!85 = !DILocation(line: 81, column: 13, scope: !76)
!86 = !DILocation(line: 81, column: 5, scope: !76)
!87 = !DILocation(line: 83, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !76, file: !8, line: 81, column: 21)
!89 = !DILocation(line: 83, column: 9, scope: !90)
!90 = distinct !DILexicalBlock(scope: !88, file: !8, line: 83, column: 9)
!91 = !DILocation(line: 84, column: 9, scope: !88)
!92 = !DILocation(line: 86, column: 9, scope: !88)
!93 = !DILocation(line: 86, column: 9, scope: !94)
!94 = distinct !DILexicalBlock(scope: !88, file: !8, line: 86, column: 9)
!95 = !DILocation(line: 87, column: 9, scope: !88)
!96 = !DILocation(line: 89, column: 9, scope: !88)
!97 = !DILocation(line: 89, column: 9, scope: !98)
!98 = distinct !DILexicalBlock(scope: !88, file: !8, line: 89, column: 9)
!99 = !DILocation(line: 90, column: 9, scope: !88)
!100 = !DILocation(line: 92, column: 5, scope: !76)
!101 = distinct !DISubprogram(name: "usb_register_notify", scope: !8, file: !8, line: 66, type: !102, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !32)
!102 = !DISubroutineType(types: !103)
!103 = !{null, !6}
!104 = !DILocalVariable(name: "nb", arg: 1, scope: !101, file: !8, line: 66, type: !6)
!105 = !DILocation(line: 66, column: 63, scope: !101)
!106 = !DILocation(line: 68, column: 28, scope: !101)
!107 = !DILocation(line: 68, column: 26, scope: !101)
!108 = !DILocation(line: 69, column: 1, scope: !101)
!109 = distinct !DISubprogram(name: "usb_logger_exit_buggy", scope: !29, file: !29, line: 122, type: !110, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !32)
!110 = !DISubroutineType(types: !111)
!111 = !{null}
!112 = !DILocation(line: 125, column: 1, scope: !109)
!113 = distinct !DISubprogram(name: "deliver_usb_event", scope: !8, file: !8, line: 96, type: !114, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !32)
!114 = !DISubroutineType(types: !115)
!115 = !{!15, !5, !16}
!116 = !DILocalVariable(name: "action", arg: 1, scope: !113, file: !8, line: 96, type: !5)
!117 = !DILocation(line: 96, column: 44, scope: !113)
!118 = !DILocalVariable(name: "dev", arg: 2, scope: !113, file: !8, line: 96, type: !16)
!119 = !DILocation(line: 96, column: 58, scope: !113)
!120 = !DILocalVariable(name: "nb", scope: !113, file: !8, line: 98, type: !6)
!121 = !DILocation(line: 98, column: 28, scope: !113)
!122 = !DILocation(line: 98, column: 33, scope: !113)
!123 = !DILocation(line: 99, column: 10, scope: !124)
!124 = distinct !DILexicalBlock(scope: !113, file: !8, line: 99, column: 9)
!125 = !DILocation(line: 99, column: 9, scope: !113)
!126 = !DILocation(line: 100, column: 9, scope: !124)
!127 = !DILocation(line: 118, column: 12, scope: !128)
!128 = !DILexicalBlockFile(scope: !113, file: !29, discriminator: 0)
!129 = !DILocation(line: 118, column: 16, scope: !128)
!130 = !DILocation(line: 118, column: 30, scope: !128)
!131 = !DILocation(line: 118, column: 34, scope: !128)
!132 = !DILocation(line: 118, column: 42, scope: !128)
!133 = !DILocation(line: 118, column: 5, scope: !128)
!134 = !DILocation(line: 119, column: 1, scope: !128)
