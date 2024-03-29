import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_shop/ui/product/bloc/product_bloc.dart';
import 'package:nike_shop/ui/product/product.dart';
import 'package:nike_shop/ui/widgets/error.dart';

class ProductListScreen extends StatefulWidget {
  final int sortId;

  const ProductListScreen({
    super.key,
    required this.sortId,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType {
  grid,
  list,
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
        centerTitle: false,
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(sort: widget.sortId));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              return Column(
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.2),
                              width: 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  top: 24,
                                  bottom: 24,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 230,
                                child: Column(
                                  children: [
                                    Text('انتخاب مرتب سازی'),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.sortNames.length,
                                        itemBuilder: (context, index) {
                                          final selectedSortIndex = state.sort;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: SizedBox(
                                              width: 32,
                                              child: InkWell(
                                                onTap: () {
                                                  bloc?.add(
                                                    ProductListStarted(
                                                        sort: index),
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      state.sortNames[index],
                                                    ),
                                                    const SizedBox(width: 8),
                                                    if (index ==
                                                        selectedSortIndex)
                                                      Icon(
                                                        CupertinoIcons
                                                            .check_mark_circled_solid,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const IconButton(
                                    onPressed: null,
                                    icon: Icon(CupertinoIcons.sort_down),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('مرتب سازی'),
                                      Text(
                                        state.sortNames[state.sort],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.2),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.grid
                                      ? ViewType.list
                                      : ViewType.grid;
                                });
                              },
                              icon: Icon(viewType == ViewType.list
                                  ? CupertinoIcons.square_grid_2x2
                                  : CupertinoIcons.list_bullet),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => Future.sync(() {
                        bloc?.add(
                          ProductListStarted(sort: widget.sortId),
                        );
                      }),
                      child: GridView.builder(
                        itemCount: state.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: viewType == ViewType.grid ? 2 : 1,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          return ProductItem(
                            product: state.products[index],
                            borderRadius: BorderRadius.zero,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ProductListloading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is ProductListError) {
              return Center(
                child: AppErrorWidget(
                  exception: state.appException,
                  onPressed: () {},
                ),
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
