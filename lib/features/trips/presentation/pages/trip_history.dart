import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/become_a_driver_card.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_details.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/history_sections.dart';
import 'package:rideme_mobile/injection_container.dart';

class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  final tripsBloc = sl<TripsBloc>();
  ScrollController historyListingController = ScrollController();

  fetchDetails({
    required List<AllTripDetails> currentList,
    required int page,
  }) {
    final params = {
      'locale': context.read<LocaleProvider>().locale,
      'bearer': context.read<AuthenticationProvider>().token!,
      'queryParameters': {
        'page': page.toString(),
      },
    };

    tripsBloc.add(GetAllTripsEvent(params: params, currentList: currentList));
  }

  @override
  void initState() {
    fetchDetails(
      currentList: [],
      page: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.appLocalizations.tripHistory,
          style: context.textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Sizes.height(context, 0.02)),
        child: Column(
          children: [
            Space.height(context, 0.02),
            const BecomeADriverCard(),
            Space.height(context, 0.035),
            BlocBuilder(
              bloc: tripsBloc,
              buildWhen: (previous, current) =>
                  previous != current && current is GetAllTripLoaded,
              builder: (context, state) {
                if (state is GenericTripsError) {
                  return Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'An error occured',
                        style: context.textTheme.displayMedium?.copyWith(
                          color: AppColors.rideMeErrorNormal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          fetchDetails(currentList: [], page: 1);
                        },
                        child: Text(
                          context.appLocalizations.retry,
                          style: context.textTheme.displayMedium?.copyWith(
                            color: AppColors.rideMeBlueNormal,
                            decorationColor: AppColors.rideMeBlueNormal,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ));
                }

                if (state is GetAllTripLoaded) {
                  final tripHistory =
                      tripsBloc.getCategorizedTripsHistory(state.tripDetails);

                  final currentPage = state
                          .allTripsInfo.allTripsData?.pagination?.currentPage ??
                      0;
                  final lastPage =
                      state.allTripsInfo.allTripsData?.pagination?.lastPage ??
                          0;

                  historyListingController.addListener(
                    () {
                      //check if scrolled to the end

                      if (historyListingController.position.pixels ==
                              historyListingController
                                  .position.maxScrollExtent &&
                          (currentPage < lastPage)) {
                        fetchDetails(
                          currentList: state.tripDetails,
                          page: currentPage + 1,
                        );
                      }
                    },
                  );

                  return state.tripDetails.isEmpty
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   ImageNameConstants.file,
                              //   width: Sizes.width(context, 0.196),
                              // ),
                              Space.height(context, 0.06),
                              Text(
                                context.appLocalizations.noTripsTitle,
                                style:
                                    context.textTheme.displayMedium?.copyWith(),
                              ),
                              Space.height(context, 0.08),
                              Text(
                                context.appLocalizations.noTripsSubtitle,
                                style: context.textTheme.displaySmall?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      //history sections
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tripHistory.length + 1,
                            controller: historyListingController,
                            itemBuilder: (context, index) {
                              if (index < tripHistory.length) {
                                return HistorySections(
                                  label: tripHistory[index].key,
                                  items: tripHistory[index].value,
                                );
                              } else {
                                if (currentPage != lastPage) {
                                  return const LoadingIndicator();
                                } else {
                                  return const SizedBox();
                                }
                              }
                            },
                          ),
                        );
                }

                return const LoadingIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
