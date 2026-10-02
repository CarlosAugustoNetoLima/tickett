<?php $term =  isset($term) ? $term : '' ?>


    <div class="search-bar" style="width: 30%;">
            <form action="{{ url() }}search" class="search-form">
                <div class="input-group searchBtn" style="border: 0px;">
                    <input name="term" type="text" placeholder="{{ t._('Nome do Evento, País, Cidade, Local') }}"
                        class="form-control text-search" value="<?php echo isset($term) ? $term : '' ; ?>"
                        style="display: flex; border: 1px solid #f0f0f0; border-radius: 30px 0 0 30px; background-color: #ffffff00; color: #f0f0f0; height: 40px;">
                    <div class="input-group-prepend" style="height: 40px;">


                       
                        
                        <button class="btn btn-outline-secondary" type="submit"
                            style="display: flex; border: 1px solid #f0f0f0; border-radius: 0 30px 30px 0; background-color: #ffffff00; ">
                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                                fill="none" stroke="#FFFFFF" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                        </button>
                    </div>
                </div>
            </form>
    </div>

