<section class="page-title">
    <div class="container">
        <h1 class="title">{{ t._('helpdesk') }}</h1>
    </div>
</section>

{{ partial('account/menu') }}





<section class="page-support">
    <div class="container">

                        {{ content() }}
                        {{ flashSession.output() }}

        <div class="page-support-inner internal-page">
            <div class="internal-page-title">
                <h2 class="title">{{ t._('all_helpdesks') }}</h2>
            </div>
            <div class="table-area">
                <table class="table table-blue">
                    <thead class="table-head">
                        <tr>
                            <th width="220">{{ t._('number_helpdesk') }}</th>
                            <th width="100">{{ t._('date') }}</th>
                            <th>{{ t._('subject') }}</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody class="table-body">
                        <?php
                        foreach ( $helpdesks AS $helpdesk ) :
                            ?>
                            <tr>
                                <td>
                                    <a href="{{ url() }}account/helpdesk/{{ helpdesk.id }}" class="btn btn-outline-primary">#{{ helpdesk.id }}</a>
                                </td>
                                <td>
                                    <?php echo $this->getDI()->getFormatdates()->format($helpdesk->created_at, '25/01/2000') ?>
                                </td>
                                <td>
                                    {{ helpdesk.subject }}
                                </td>
                                <td class="button-column">
                                    <a href="{{ url() }}account/helpdesk/{{ helpdesk.id }}" class="btn btn-outline-primary">{{ t._('View') }}</a>
                                </td>
                            </tr>
                        <?php endforeach ; ?>
                        <?php if (  count($helpdesks) == 0 ) : ?>
                            <tr>
                                <td colspan="4">{{ t._('not_having_helpdesks') }}</td>
                            </tr>
				        <?php endif ; ?>
                    </tbody>
                </table>
            </div>

            <?php /*
            <div class="contact-area">
                <div class="contact-title">
                    <h3 class="title">{{ t._('start_a_new_contact') }}</h3>
                </div>
                <div class="contact-form">
                    <form class="form" method="POST" action="{{ url() }}account/support">
                        <div class="form-group">
                            <label for="subject">{{ t._('subject') }}</label>
                            <input type="text" class="form-control" id="new_request_subject" name="subject" placeholder="{{ t._('subject') }}">
                        </div>
                        <div class="form-group">
                            <label for="message">{{ t._('message') }}</label>
                            <textarea class="form-control" id="new_request_message" name="message" rows="5" placeholder="{{ t._('message') }}"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">{{ t._('send_message') }}</button>
                    </form>
                </div>
            </div>
            */ ?>

        </div>
    </div>
</section>